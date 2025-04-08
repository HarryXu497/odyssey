import 'package:flutter/material.dart';
import 'package:odyssey/models/containers/container_item_model.dart';
import 'package:odyssey/models/items/item_model.dart';
import 'package:odyssey/pocketbase.dart';
import 'package:odyssey/screens/screen_with_navigation.dart';
import 'package:pocketbase/pocketbase.dart';

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
    
    await pb
        .collection("items")
        .subscribe('*', _listener);
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

class ContainerScreenBody extends StatelessWidget {
  final ContainerItemModel containerItemModel;
  const ContainerScreenBody({
    super.key,
    required this.containerItemModel,
  });

  void Function(bool?) _onItemChecked(ItemModel itemModel) {
    return (newValue) async {
      await pb
          .collection("items")
          .update(itemModel.id, body: {
            "checked": newValue ?? false,
          });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final item = containerItemModel.itemModels[index];

          return CheckboxListTile(
            value: item.checked,
            onChanged: _onItemChecked(item),
            title: Text(item.name),
          );
        },
        itemCount: containerItemModel.itemModels.length,
      ),
    );
  }
}
