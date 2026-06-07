import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/sections_constants.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.dart';
import 'package:sistema_escolar_bnl/view_models/sections_vm.dart';
import 'package:trina_grid/trina_grid.dart';

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

    return QueryTable(
      queryKey: kSectionsKey,
      queryFn: vm.repository.getSections,
      setStateManager: vm.setStateManager,
      errorTitle: 'Error al cargar las secciones',
      onChanged: updateMutation.mutate,
      getCells: (section) {
        // final studentCount = r.nextInt(section.capacity);
        final studentCount = section.studentCount;

        return {
          SectionsTableColumns.grade.name: TrinaCell(value: section.gradeName),

          SectionsTableColumns.letter.name: TrinaCell(value: section.letter),

          SectionsTableColumns.capacity.name: TrinaCell(
            value: section.capacity,
          ),

          SectionsTableColumns.studentsCount.name: TrinaCell(
            value: studentCount,
          ),

          SectionsTableColumns.enrollment.name: TrinaCell(
            value: section.capacity - studentCount,
          ),
        };
      },
      getColumns: (context) => [
        .new(
          title: 'Grado',
          field: SectionsTableColumns.grade.name,
          type: .text(),
          width: 150,
          suppressedAutoSize: true,
          enableContextMenu: false,
          enableEditingMode: false,
        ),

        .new(
          title: 'Letra',
          field: SectionsTableColumns.letter.name,
          type: .text(),
          titleTextAlign: .center,
          textAlign: .center,
          width: 80,
          suppressedAutoSize: true,
          enableContextMenu: false,
          enableColumnDrag: false,
          enableDropToResize: false,
        ),

        .new(
          title: 'Capacidad',
          field: SectionsTableColumns.capacity.name,
          type: .number(),
          textAlign: .right,
        ),

        .new(
          title: 'Estudiantes',
          field: SectionsTableColumns.studentsCount.name,
          type: .number(),
          textAlign: .right,
          enableAutoEditing: false,
          enableEditingMode: false,
        ),

        .new(
          title: 'Matrícula',
          field: SectionsTableColumns.enrollment.name,
          type: .custom(),
          enableEditingMode: false,
          enableAutoEditing: false,
          enableSorting: false,
          enableFilterMenuItem: false,
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
      actionsWidth: 220,
      actionsRenderer: (ctx) {
        return Center(
          child: Row(
            spacing: 10,
            mainAxisAlignment: .center,
            children: [
              ShadButton.secondary(
                height: 30,
                child: const Text('Ver matrícula'),
              ),

              ShadIconButton.destructive(
                height: 30,
                width: 30,
                iconSize: 20,
                onPressed: () {
                  confirmDeletion(
                    context,
                    title: '¿Realmente quieres eliminar esta sección?',
                    msg: 'Esta acción no se puede deshacer.',
                    onConfirmed: () => deleteMutation.mutate(ctx),
                  );
                },
                icon: const Icon(Icons.delete_outline_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
