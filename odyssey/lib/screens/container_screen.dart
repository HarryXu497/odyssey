import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odyssey/models/containers/container_item_model.dart';
import 'package:odyssey/models/items/item_model.dart';
import 'package:odyssey/pocketbase.dart';
import 'package:odyssey/routes/remote_urls.dart';
import 'package:odyssey/screens/add_item_screen.dart';
import 'package:odyssey/screens/screen_with_navigation.dart';
import 'package:odyssey/widgets/buttons/styled_button.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class ContainerScreen extends StatefulWidget {
  final String containerId;
  const ContainerScreen({
    super.key,
    required this.containerId,
  });

  @override
  State<ContainerScreen> createState() =>
      _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  ContainerItemModel? _containerItemModel;

  Future<ContainerItemModel> _getContainer() async {
    final containerDocuments = await pb
        .collection("containers")
        .getOne(widget.containerId, expand: "items");

    return ContainerItemModel.fromExpandedRecord(
      containerDocuments,
    );
  }

  void _listener(RecordSubscriptionEvent e) async {
    final containerItemModel = await _getContainer();

    setState(() {
      _containerItemModel = containerItemModel;
    });
  }

  void initListener() async {
    final initialFetch = await _getContainer();

    setState(() {
      _containerItemModel = initialFetch;
    });

    await pb
        .collection("containers")
        .subscribe('*', _listener);

    await pb.collection("items").subscribe('*', _listener);
  }

  void disposeListener() async {
    await pb.collection("containers").unsubscribe('*');
  }

  @override
  void initState() {
    super.initState();

    initListener();
  }

  @override
  void dispose() {
    super.dispose();

    disposeListener();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithNavigation(
      appBar: AppBar(
        title: Text(
          _containerItemModel == null
              ? ""
              : _containerItemModel!.containerModel.name
                  .toUpperCase(),
          style: Theme.of(context).textTheme.headlineLarge,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primary,
        foregroundColor:
            Theme.of(context).colorScheme.onPrimary,
      ),
      body:
          _containerItemModel == null
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : ContainerScreenBody(
                containerItemModel: _containerItemModel!,
              ),
    );
  }
}

class ContainerScreenBody extends StatefulWidget {
  final ContainerItemModel containerItemModel;

  const ContainerScreenBody({
    super.key,
    required this.containerItemModel,
  });

  @override
  State<ContainerScreenBody> createState() =>
      ContainerScreenBodyState();
}

class ContainerScreenBodyState
    extends State<ContainerScreenBody> {
  Future _takePhoto(BuildContext context) async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => CameraGalleryModal(),
    );

    if (isCamera == null) return;

    final imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source:
          isCamera
              ? ImageSource.camera
              : ImageSource.gallery,
    );

    if (file != null) {
      final uri = Uri.parse(RemoteUrls.photoServerUrl);
      final request = http.MultipartRequest("POST", uri);
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          await file.readAsBytes(),
          filename: file.name,
          contentType: MediaType.parse(
            file.mimeType ?? "image/heic",
          ),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(
        streamedResponse,
      );

      final responseData = json.decode(response.body);

      final responseItems =
          responseData["items"] as List<dynamic>;

      final models = await Future.wait(
        responseItems.map((item) async {
          return pb
              .collection("items")
              .create(
                body: {
                  "name": item["class_name"] as String,
                  "checked": false,
                },
              );
        }),
      );

      await pb
          .collection("containers")
          .update(
            widget.containerItemModel.containerModel.id,
            body: {
              "items+":
                  models.map((item) => item.id).toList(),
            },
          );
    }
  }

  void initButtons() {
    listTileButtons = [
      ListTileButton(
        text: "add more",
        onTap: () async {
          final String result = await Navigator.of(
            context,
          ).push(
            MaterialPageRoute(
              builder: (_) => AddItemScreen(),
            ),
          );

          final item = await pb
              .collection("items")
              .create(
                body: {"name": result, "checked": false},
              );

          await pb
              .collection("containers")
              .update(
                widget.containerItemModel.containerModel.id,
                body: {
                  "items+": [item.id],
                },
              );
        },
      ),
      ListTileButton(
        text: "recommend with ai",
        onTap: () {},
      ),
      ListTileButton(
        text: "take a photo",
        onTap: () async => await _takePhoto(context),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    initButtons();
  }

  List<Widget>? listTileButtons;

  void Function(bool?) _onItemChecked(ItemModel itemModel) {
    return (newValue) async {
      await pb
          .collection("items")
          .update(
            itemModel.id,
            body: {"checked": newValue ?? false},
          );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder:
                (_, _) => HorizontalLineSeparator(),
            itemBuilder: (context, index) {
              final item =
                  widget
                      .containerItemModel
                      .itemModels[index];

              return CheckboxListTile(
                value: item.checked,
                onChanged: _onItemChecked(item),
                title: Text(
                  item.name.toLowerCase(),
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleMedium,
                ),
              );
            },
            itemCount:
                widget.containerItemModel.itemModels.length,
          ),
          HorizontalLineSeparator(),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder:
                (context, index) => listTileButtons![index],
            separatorBuilder:
                (_, _) => HorizontalLineSeparator(),
            itemCount: listTileButtons!.length,
          ),
        ],
      ),
    );
  }
}

class ListTileButton extends StatelessWidget {
  final void Function() onTap;
  final String text;

  const ListTileButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

class HorizontalLineSeparator extends StatelessWidget {
  const HorizontalLineSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}

class CameraGalleryModal extends StatelessWidget {
  const CameraGalleryModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          StyledButton(
            child: Text(
              "camera",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(
                color:
                    Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          SizedBox(height: 8.0),
          StyledButton(
            child: Text(
              "gallery",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(
                color:
                    Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
