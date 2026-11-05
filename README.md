# Tonalis (Flutter)

Application mobile (iOS et Android) pour apprendre le mandarin (HSK 1) quand on parle français.
**Version 0.2.1.** Le code Flutter n'a pas pu être compilé dans l'environnement où il a été écrit : lancez `flutter analyze` après l'installation. La logique pure (vocabulaire, révisions, recherche) est vérifiée par `dart run tool/check.dart`.

## Obtenir l'APK sans installer Flutter
Voir `LISEZMOI-APK.txt` : le workflow GitHub Actions `.github/workflows/build-apk.yml` construit l'APK Android dans le cloud.

## Démarrage
1. Installer Flutter (3.22 ou plus récent).
2. Dans ce dossier : `flutter create . --org com.tonalis --project-name tonalis` (génère android/ et ios/ sans écraser lib/ ni pubspec.yaml).
3. `flutter pub get` puis `flutter run`.
4. Vérifier la logique sans émulateur : `dart run tool/check.dart`.

## Ce qui est là
- **151 mots HSK 1** en 16 unités thématiques (Salutations, Nombres, Famille, Le temps, Se déplacer…), découpées en 36 leçons de 3 à 5 mots.
- **Leçons variées** : présentation avec audio, QCM caractère → français, français → caractère, écoute → caractère, écriture au doigt. Retour immédiat (bonne réponse / réponse attendue avec pinyin), les mots ratés reviennent en fin de leçon, écran de fin avec score et XP.
- **Révisions espacées FSRS** (FSRS 4.5, poids par défaut, rétention visée 90 %) à la place des boîtes de Leitner : chaque bouton annonce le prochain intervalle, sessions de 30 cartes, pastille du nombre de mots à réviser sur l'onglet.
- **Accueil** : objectif quotidien (20 XP), carte « mots à réviser », progression par unité, prochaine leçon mise en avant.
- **Dico** : recherche sans accents ni tons (`xie xie`, `merci`, `nv` pour 女, ou le caractère), mots déjà appris cochés.
- **Profil** : niveau et titre, leçons, mots appris et bien maîtrisés, nombre de révisions.
- **Fiabilité** : jour local (la série ne se coupe plus à minuit UTC), série remise à 0 si un jour est manqué, lecture tolérante de la sauvegarde (copie `state_corrupt_backup` si elle est illisible), migration automatique depuis l'ancien format (boîtes de Leitner). La progression des leçons de la v0.1 repart de zéro (la numérotation a changé) ; les mots déjà appris sont conservés. L'appli reste utilisable sans voix chinoise installée.
- Thème rouge cinabre / or, mode sombre automatique, voix système zh-CN (flutter_tts), progression enregistrée localement.

## Prochaines étapes recommandées
1. Remplacer la synthèse vocale par des enregistrements natifs (just_audio, fichiers téléchargés par unité pour le mode hors-ligne).
2. Écriture : intégrer les données de traits Make Me a Hanzi (vérifier la licence) pour animer et valider chaque trait.
3. Enregistrement de la voix (package record) et courbe de hauteur F0, comme dans le prototype.
4. Phrases utiles, dialogues, onboarding et rappels quotidiens (flutter_local_notifications), repris du prototype web.
5. Comptes et classements (Supabase ou Firebase), abonnement (RevenueCat), scanner (google_mlkit_text_recognition).
6. Entraîner les poids FSRS sur vos propres révisions une fois qu'il y en a assez.
