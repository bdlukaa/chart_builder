import 'package:flutter/material.dart';

import '../lang.dart';
import '../../models/chart.dart';

class PortugueseLocalization extends BaseLocalization {
  PortugueseLocalization() : super(code: 'pt', name: 'Português');

  String get flag => 'br';
  String get appTitle => 'Criador de gráficos';

  // Settings
  String get settings => 'Configurações';
  // Theme
  String get appTheme => 'Tema';
  String themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'Escuro';
      case ThemeMode.system:
        return 'Sistema';
      case ThemeMode.light:
        return 'Claro';
      default:
        return '';
    }
  }

  // Language
  String get language => 'Idioma';

  // Buttons
  String get newButton => 'Novo';
  String get undo => 'DESFAZER';

  String get noChartsCreated => 'Você não criou nenhum gráfico.';
  String get noLineChartsCreated => 'Você não criou nenhum gráfico de linha.';
  String get noBarChartsCreated => 'Você não criou nenhum gráfico de barra.';
  String get noPieChartsCreated => 'Você não criou nenhum gráfico de pizza.';
  String get noScatterChartsCreated =>
      'Você não criou nenhum gráfico de dispersão.';

  String get save => 'Salvar';
  String get back => 'Voltar';
  String get delete => 'Deletar';

  String get add => 'Adidionar';

  String get editButton => 'Editar';
  String get cancel => 'Cancelar';
  String get done => 'Pronto';

  String get takeScreenshot => 'Tirar print';
  String get bookmark => 'Favoritar';

  // New chart
  String get newChart => 'Novo gráfico';
  String get newLineChart => 'Linha';
  String get newBarChart => 'Barra';
  String get newPieChart => 'Pizza';
  String get newScatterChart => 'Dispersão';
  String chartGeneratedName(ChartType type, int number) {
    switch (type) {
      case ChartType.bar:
        return 'Gráfico de Barra $number';
        break;
      case ChartType.pie:
        return 'Gráfico de Pizza $number';
        break;
      case ChartType.line:
        return 'Gráfico de Linha $number';
        break;
      case ChartType.scatter:
        return 'Gráfico de Dispersão $number';
        break;
      default:
        return 'Gráfico $number';
    }
  }

  String get chartName => 'Nome do gráfico';

  String get create => 'Criar';

  // Errors
  String get canNotBeEmpty => 'Este não pode estar vazio';

  // General Charts
  String get backgroundColor => 'Cor de fundo';
  String get border => 'Borda';
  String get borderColor => 'Cor da borda';
  String get borderWidth => 'Tamanho da borda';

  String get value => 'Valor';

  String get edit => 'Edição';
  String get preview => 'Visualização';

  String saved(String name) => '${name ?? Chart} foi salvo';
  String deleted(String name) => '${name ?? 'Chart'} foi deletado';

  String get options => 'Opções';

  // Danger zone
  String get dangerZone => 'Zona de perigo';

  String get deleteThisChart => 'Deletar esse gráfico';
  String get deleteThisChartDesc =>
      'Uma vez deletado, não poderá voltar a trás. Tenha certeza';

  // Pie charts
  String get centerSpaceRadius => 'Tamanho do centro';
  String get centerSpaceColor => 'Cor do centro';
  String get rotationDegree => 'Grau de rotação';
  String get sectionsSpace => 'Espaçamento entre as seções';

  String get sections => 'Seções';

  String get center => 'Centro';

  // Pie charts/sections
  String get title => 'Título';
  String get sectionColor => 'Cor da seção';
  String get radius => 'Raio';
  String get showTitle => 'Mostrar título';
  String get titlePosition => 'Posição do título';

  // Leave dialog
  String get areYouSure => 'Você tem certeza?';
  String get areYouSureDescription =>
      'Você tem certeza que quer sair sem salvar seu progresso';

  String get leave => 'Sair';
  String get saveAndLeave => 'Salvar e sair';
  String get dismiss => 'Dispensar';

  // Hints
  String get slideToSideToDeleteSection =>
      'Dica: arraste para qualquer lado para deletar uma seção';
  String get longPressSectionToEdit =>
      'Dica: aperte e segure numa seção para editá-la';
  String get longPressChartToOptions =>
      'Dica: aperte e segura num gráfico para ver as opções';
}
