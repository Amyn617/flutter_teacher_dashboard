# Tableau de Bord de l'Enseignant

## Aperçu du Projet

Ce projet est une application Flutter conçue pour aider les enseignants à gérer leurs classes, suivre l'assiduité des étudiants et organiser leur emploi du temps. L'application fournit un tableau de bord centralisé affichant des informations clés et des raccourcis vers différentes fonctionnalités.

## Structure du Projet

Le projet suit une structure Flutter standard. Voici les principaux répertoires et leur contenu :

- **`lib/`**: Contient tout le code source Dart de l'application.
  - **`main.dart`**: Le point d'entrée principal de l'application.
  - **`models/`**: Définit les structures de données (modèles) utilisées dans l'application, telles que `ClassModel` (informations sur les cours), `StudentModel` (informations sur les étudiants) et `AttendanceModel` (suivi de l'assiduité).
  - **`pages/`**: Contient les différents écrans (ou pages) de l'application. Chaque fichier `.dart` ici représente généralement une vue distincte.
    - `dashboard_page.dart`: L'écran principal affichant un aperçu général.
    - `class_detail_page.dart`: Affiche les détails d'un cours spécifique.
    - `add_class_page.dart`: Permet d'ajouter de nouveaux cours.
    - `schedule_page_new.dart` / `schedule_page.dart`: Pages relatives à l'emploi du temps.
    - `reports_page_new.dart` / `reports_page.dart`: Pages pour la visualisation des rapports d'assiduité.
    - `settings_page.dart`: Écran des paramètres de l'application.
    - `main_navigation_wrapper.dart`: Gère la navigation principale de l'application (par exemple, la barre de navigation inférieure).
  - **`services/`**: Contient la logique métier et les services, comme `AttendanceService` qui gère les opérations liées à l'assiduité.
  - **`theme/`**: Définit le thème visuel de l'application (couleurs, polices, etc.) dans `app_theme.dart`.
  - **`widgets/`**: Contient les composants d'interface utilisateur réutilisables (widgets) utilisés à travers l'application.
- **`assets/`**: Stocke les actifs statiques tels que les images, les icônes et les animations.
  - `animations/`: Animations Lottie ou autres.
  - `icons/`: Icônes personnalisées.
  - `images/`: Images utilisées dans l'application.
- **`android/`**, **`ios/`**, **`web/`**, **`windows/`**, **`linux/`**, **`macos/`**: Contiennent le code spécifique à chaque plateforme pour la compilation et l'exécution de l'application Flutter sur ces plateformes.
- **`pubspec.yaml`**: Le fichier de configuration du projet Flutter. Il liste les dépendances du projet (packages), les polices, les actifs, et d'autres métadonnées du projet.
- **`test/`**: Contient les tests unitaires et les tests de widgets.

## Composants Clés du Code (Widgets et Classes)

Voici quelques-uns des widgets et classes importants de l'application :

### Widgets Principaux

1.  **`ClassCard` (`lib/widgets/class_card.dart`)**:

    - **Description**: Un widget carte qui affiche un résumé des informations d'un cours, y compris le nom du cours, la matière, le nombre total d'étudiants, l'horaire, la salle et les jours. Il affiche également le taux de présence moyen pour le cours avec un indicateur de couleur.
    - **Utilisation**: Utilisé dans les listes pour donner un aperçu rapide de chaque cours. Permet une navigation vers les détails du cours via `onTap`.
    - **Logique importante**: Calcule le taux de présence moyen en utilisant `AttendanceService` et change la couleur de fond de l'indicateur de présence (`_getAttendanceColor`) en fonction de ce taux (vert pour élevé, orange pour moyen, rouge pour faible).
    - **Extrait de Code**:
      ```dart
      // Dans lib/widgets/class_card.dart
      // ...
      Color _getAttendanceColor(double rate) {
        if (rate >= 80) {
          return Colors.green;
        } else if (rate >= 60) {
          return Colors.orange;
        } else {
          return Colors.red;
        }
      }
      // ...
      // Exemple d'utilisation dans la méthode build:
      // Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      //   decoration: BoxDecoration(
      //     color: _getAttendanceColor(avgAttendanceRate).withAlpha(200),
      //     borderRadius: BorderRadius.circular(16),
      //   ),
      //   child: Text(
      //     '${avgAttendanceRate.toStringAsFixed(1)}%',
      //     style: theme.textTheme.bodyMedium?.copyWith(
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      // ...
      ```

2.  **`StickyAppBar` (`lib/widgets/sticky_app_bar.dart`)**:

    - **Description**: Une barre d'application personnalisée (`SliverAppBar`) qui peut rester "collée" en haut de l'écran lors du défilement. Elle affiche un titre, un sous-titre optionnel, et peut inclure des actions.
    - **Utilisation**: Fournit une expérience utilisateur cohérente pour les titres de page, en particulier dans les écrans à défilement.
    - **Caractéristiques**: Gère l'apparence en mode clair et sombre, et utilise un `FlexibleSpaceBar` pour un effet de titre qui se réduit lors du défilement.

3.  **`SummaryCard` (`lib/widgets/summary_card.dart`)**:

    - **Description**: Une carte simple utilisée pour afficher une information concise, généralement une statistique ou un résumé. Elle se compose d'une icône, d'un titre et d'une valeur.
    - **Utilisation**: Souvent utilisée sur le tableau de bord pour afficher des métriques clés comme "Nombre total de cours", "Étudiants actifs", etc.
    - **Personnalisation**: La couleur de l'icône et de son arrière-plan peut être personnalisée.

4.  **`UpcomingClass` (`lib/widgets/upcoming_class.dart`)**:

    - **Description**: Un widget conçu pour afficher les informations d'un cours à venir. Il met en évidence l'heure de début, le nom du cours, la matière, la salle et le nombre d'étudiants.
    - **Utilisation**: Typiquement affiché sur le tableau de bord ou une page d'emploi du temps pour informer l'enseignant des prochains cours.
    - **Design**: Possède une petite barre latérale colorée pour une distinction visuelle et s'adapte aux thèmes clair et sombre.

5.  **`CalendarCard` (`lib/widgets/calendar_card.dart`)**:
    - **Description**: Affiche la date actuelle (jour de la semaine, jour du mois, mois, année) dans un format de carte. Inclut un bouton pour naviguer vers une vue de calendrier complète.
    - **Utilisation**: Généralement sur le tableau de bord pour un accès rapide aux informations calendaires.

### Modèles de Données (`lib/models/`)

1.  **`ClassModel` (`lib/models/class_model.dart`)**:

    - **Description**: Représente un cours. Contient des propriétés telles que `id`, `name` (nom du cours), `subject` (matière), `totalStudents`, `time` (horaire), `room` (salle), et `days` (jours de la semaine où le cours a lieu).
    - **Importance**: Structure de données centrale pour la gestion des informations des cours.

2.  **`AttendanceModel` (`lib/models/attendance_model.dart`)**:
    - **Description**: Représente un enregistrement d'assiduité pour un cours à une date spécifique. Contient des informations comme `classId`, `date`, et `attendanceRate` (taux de présence).
    - **Importance**: Utilisé par `AttendanceService` pour stocker et récupérer les données d'assiduité.

### Services (`lib/services/`)

1.  **`AttendanceService` (`lib/services/attendance_service.dart`)**:

    - **Description**: Gère toute la logique liée à l'assiduité. Cela inclut l'enregistrement de la présence, la récupération des enregistrements d'assiduité pour un cours spécifique, et potentiellement le calcul de statistiques d'assiduité.
    - **Importance**: Centralise la gestion des données d'assiduité, rendant le code des widgets plus propre et plus focalisé sur la présentation.
    - **Extrait de Code**:

      ```dart
      // Dans lib/services/attendance_service.dart
      // ...
      void addAttendanceRecord(AttendanceRecord record) {
        final existingRecordIndex = _attendanceRecords.indexWhere(
          (r) => r.classId == record.classId && isSameDay(r.date, record.date),
        );

        if (existingRecordIndex != -1) {
          _attendanceRecords[existingRecordIndex] = record;
        } else {
          _attendanceRecords.add(record);
        }
        notifyListeners();
      }

      Map<String, double> getWeeklyAttendanceStats(String classId) {
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        Map<String, double> stats = {};
        for (int i = 0; i < 7; i++) {
          final day = startOfWeek.add(Duration(days: i));
          final record = getAttendanceRecord(classId, day);
          stats[_getDayName(day.weekday)] = record?.attendanceRate ?? 0.0;
        }
        return stats;
      }
      // ...
      ```

### Thème (`lib/theme/`)

1.  **`AppTheme` (`lib/theme/app_theme.dart`)**:

    - **Description**: Définit les couleurs primaires, secondaires, les styles de texte, et d'autres aspects visuels de l'application pour les modes clair et sombre.
    - **Importance**: Assure une apparence cohérente à travers toute l'application.
    - **Extrait de Code**:

      ```dart
      // Dans lib/theme/app_theme.dart
      // ...
      static ThemeData get lightTheme {
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor,
            primary: primaryColor,
            secondary: secondaryColor,
            // ... autres couleurs
            brightness: Brightness.light,
          ),
          // ... appBarTheme, cardTheme, textTheme, etc.
        );
      }

      static ThemeData get darkTheme {
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor,
            primary: primaryColor, // Peut être ajusté pour le mode sombre
            secondary: secondaryColor, // Peut être ajusté
            surface: darkSurface,
            background: darkBackground,
            // ... autres couleurs
            brightness: Brightness.dark,
          ),
          // ... appBarTheme, cardTheme, textTheme pour le mode sombre
        );
      }
      // ...
      ```

## Comment Contribuer (Exemple)

Si vous souhaitez contribuer, veuillez suivre les étapes standard de développement Flutter :

1.  Forker le dépôt.
2.  Créer une nouvelle branche pour votre fonctionnalité (`git checkout -b feature/NomDeLaFonctionnalite`).
3.  Effectuer vos modifications.
4.  Valider vos changements (`git commit -m 'Ajout de NomDeLaFonctionnalite'`).
5.  Pousser vers la branche (`git push origin feature/NomDeLaFonctionnalite`).
6.  Ouvrir une Pull Request.

---

Ce README fournit une vue d'ensemble du projet "Tableau de Bord de l'Enseignant". Pour des détails plus spécifiques, veuillez vous référer au code source et aux commentaires dans les fichiers respectifs.
