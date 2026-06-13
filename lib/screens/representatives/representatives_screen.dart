import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/representative_constants.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';
import 'package:sistema_escolar_bnl/screens/representatives/widgets/representative_form.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/buttons.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.dart';
import 'package:sistema_escolar_bnl/view_models/representative_form_vm.dart';
import 'package:sistema_escolar_bnl/view_models/representatives_vm.dart';
import 'package:trina_grid/trina_grid.dart';

class RepresentativesScreen extends StatelessWidget {
  const RepresentativesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [RepresentativesVm.instance],
      child: const _Table(),
    );
  }
}

class _Table extends HookWidget {
  const _Table();

  @override
  Widget build(BuildContext context) {
    final vm = RepresentativesVm.instance.of(context);

    final deleteMutation = vm.createDeleteMutation(context);
    final updateMutation = vm.createUpdateMutation(context);

    final format = NumberFormat.decimalPattern();

    return QueryTable(
      queryKey: kRepresentativesKey,
      queryFn: vm.repository.getRepresentatives,
      setStateManager: vm.setStateManager,
      pluralModelArticle: 'los',
      pluralModelName: 'representantes',
      onChanged: updateMutation.mutate,
      renderAddBtn: () => ProviderScope(
        providers: [RepresentativeFormVm.instance],
        child: const RepresentativeForm(),
      ),
      actionsRenderer: (ctx) {
        return Center(
          child: DeleteBtn(
            deleteMutation: deleteMutation,
            ctx: ctx,
            title: '¿Realmente quieres eliminar este representante?',
          ),
        );
      },
      getCells: (item) => {
        RepresentativesTableColumns.cedula.name: TrinaCell(value: item.cedula),

        RepresentativesTableColumns.names.name: TrinaCell(value: item.names),

        RepresentativesTableColumns.lastNames.name: TrinaCell(
          value: item.lastNames,
        ),

        RepresentativesTableColumns.phone.name: TrinaCell(value: item.phone),

        RepresentativesTableColumns.studentsCount.name: TrinaCell(
          value: item.studentsCount,
        ),

        RepresentativesTableColumns.address.name: TrinaCell(
          value: item.address,
        ),
      },
      getColumns: (context) {
        return [
          .number(
            RepresentativesTableColumns.cedula,
            width: 100,
            autoSize: false,
            renderer: (context) =>
                Text(format.format(context.cell.value), style: tabularNums),
            validate: cedulaValidator,
          ),

          .text(RepresentativesTableColumns.names, validate: nameValidator),

          .text(RepresentativesTableColumns.lastNames, validate: nameValidator),

          .text(
            RepresentativesTableColumns.phone,
            renderer: (context) => Text(context.cell.value, style: tabularNums),
            validate: RepresentativeValidators.phone,
          ),

          .number(
            RepresentativesTableColumns.studentsCount,
            width: 140,
            autoSize: false,
            editable: false,
            renderer: (context) => Row(
              mainAxisAlignment: .spaceBetween,
              spacing: 10,
              children: [
                Text(context.cell.value.toString(), style: tabularNums),

                SeeBtn(),
              ],
            ),
          ),

          .text(RepresentativesTableColumns.address),
        ];
      },
    );
  }
}
