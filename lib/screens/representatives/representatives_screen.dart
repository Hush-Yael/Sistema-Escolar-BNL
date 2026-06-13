import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/representative_constants.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';
import 'package:sistema_escolar_bnl/models/representative_models.dart';
import 'package:sistema_escolar_bnl/screens/representatives/widgets/representative_form.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/buttons.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.dart';
import 'package:sistema_escolar_bnl/view_models/representative_form_vm.dart';
import 'package:sistema_escolar_bnl/view_models/representatives_vm.dart';

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

    return QueryTable<RepresentativeWithDetails, Exception>(
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
      getColumns: (context) {
        return [
          .number(
            RepresentativesTableColumns.cedula,
            width: 100,
            autoSize: false,
            validate: cedulaValidator,
            getCellValue: (item) => item.cedula,
            renderer: (context) =>
                Text(format.format(context.cell.value), style: tabularNums),
          ),

          .text(
            RepresentativesTableColumns.names,
            validate: nameValidator,
            getCellValue: (item) => item.names,
          ),

          .text(
            RepresentativesTableColumns.lastNames,
            validate: nameValidator,
            getCellValue: (item) => item.lastNames,
          ),

          .text(
            RepresentativesTableColumns.phone,
            validate: RepresentativeValidators.phone,
            getCellValue: (item) => item.phone ?? '',
            renderer: (context) => Text(context.cell.value, style: tabularNums),
          ),

          .number(
            RepresentativesTableColumns.studentsCount,
            width: 140,
            autoSize: false,
            editable: false,
            getCellValue: (item) => item.studentsCount,
            renderer: (context) => Row(
              mainAxisAlignment: .spaceBetween,
              spacing: 10,
              children: [
                Text(context.cell.value.toString(), style: tabularNums),

                SeeBtn(),
              ],
            ),
          ),

          .text(
            RepresentativesTableColumns.address,
            getCellValue: (item) => item.address ?? '',
          ),
        ];
      },
    );
  }
}
