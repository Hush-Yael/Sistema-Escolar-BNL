import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/sections_constants.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';
import 'package:sistema_escolar_bnl/models/school_models.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/buttons.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.dart';
import 'package:sistema_escolar_bnl/view_models/sections_vm.dart';

class SectionsScreen extends HookWidget {
  const SectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [SectionsVm.instance],
      child: const ListGrades(),
    );
  }
}

class ListGrades extends HookWidget {
  const ListGrades({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = SectionsVm.instance.of(context);

    final deleteMutation = vm.createDeleteMutation(context);
    final updateMutation = vm.createUpdateMutation(context);
    // final r = Random();

    return QueryTable<SectionWithDetails, Exception>(
      queryKey: kSectionsKey,
      queryFn: vm.repository.getSections,
      setStateManager: vm.setStateManager,
      pluralModelArticle: 'las',
      pluralModelName: 'secciones',
      onChanged: updateMutation.mutate,
      getColumns: (context) => [
        .text(
          SectionsTableColumns.grade,
          width: 150,
          autoSize: false,
          editable: false,
          getCellValue: (section) => section.gradeName,
        ),

        .text(
          SectionsTableColumns.letter,
          titleTextAlign: .center,
          textAlign: .center,
          width: 100,
          autoSize: false,
          enableColumnDrag: false,
          enableDropToResize: false,
          validate: SectionValidators.letter,
          getCellValue: (section) => section.letter,
        ),

        .number(
          SectionsTableColumns.capacity,
          textAlign: .right,
          validate: SectionValidators.capacity,
          getCellValue: (section) => section.capacity,
        ),

        .number(
          SectionsTableColumns.studentsCount,
          textAlign: .right,
          editable: false,
          getCellValue: (section) => section.studentCount,
          renderer: (context) => Row(
            mainAxisAlignment: .spaceBetween,
            spacing: 10,
            children: [
              Text(context.cell.value.toString(), style: tabularNums),

              SeeBtn(),
            ],
          ),
        ),

        .new(
          SectionsTableColumns.enrollment,
          type: .custom(),
          editable: false,
          sortable: false,
          enableFilterMenuItem: false,
          getCellValue: (section) => section.capacity - section.studentCount,
          renderer: (ctx) {
            final int left = ctx.cell.value;
            final capacity =
                ctx.row.cells[SectionsTableColumns.capacity.name]!.value;

            final capacityUsed = (1 - (left / capacity)).toDouble();

            final isLow = capacityUsed < 0.5;
            final isMedium = capacityUsed < 0.75;
            final isHigh = capacityUsed < 1;

            return Column(
              mainAxisAlignment: .center,
              spacing: 6,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text("$left vacantes", style: tabularNums),

                    Text(
                      "${(capacityUsed * 100).toStringAsFixed(1)}% ocupado",
                      style: tabularNums,
                    ),
                  ],
                ),
                ShadProgress(
                  minHeight: 7,
                  value: capacityUsed,
                  color: isLow
                      ? Colors.green
                      : isMedium
                      ? Colors.yellow
                      : isHigh
                      ? Colors.orange
                      : Colors.red,
                ),
              ],
            );
          },
        ),
      ],
      actionsRenderer: (ctx) {
        return Center(
          child: DeleteBtn(
            ctx: ctx,
            deleteMutation: deleteMutation,
            title: '¿Realmente quieres eliminar esta sección?',
          ),
        );
      },
    );
  }
}
