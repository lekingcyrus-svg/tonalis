import '../models/word.dart';

// Vocabulaire HSK 1 (≈150 mots), regroupé par thèmes. Chaque unité est découpée
// automatiquement en leçons de 3 à 5 mots.
const kUnits = <Unit>[
  Unit('Salutations', [
    Word('你好', 'nǐ hǎo', 'bonjour'),
    Word('谢谢', 'xiè xie', 'merci'),
    Word('不客气', 'bú kè qi', 'de rien'),
    Word('对不起', 'duì bu qǐ', 'désolé(e)'),
    Word('没关系', 'méi guān xi', 'pas de souci'),
    Word('再见', 'zài jiàn', 'au revoir'),
    Word('请', 'qǐng', 's’il vous plaît'),
    Word('喂', 'wèi', 'allô'),
    Word('好', 'hǎo', 'bien, bon'),
    Word('不', 'bù', 'non, ne… pas'),
  ]),
  Unit('Nombres', [
    Word('一', 'yī', 'un'),
    Word('二', 'èr', 'deux'),
    Word('三', 'sān', 'trois'),
    Word('四', 'sì', 'quatre'),
    Word('五', 'wǔ', 'cinq'),
    Word('六', 'liù', 'six'),
    Word('七', 'qī', 'sept'),
    Word('八', 'bā', 'huit'),
    Word('九', 'jiǔ', 'neuf'),
    Word('十', 'shí', 'dix'),
    Word('几', 'jǐ', 'combien (petit nombre)'),
    Word('多少', 'duō shao', 'combien (quantité)'),
  ]),
  Unit('Moi et toi', [
    Word('我', 'wǒ', 'je, moi'),
    Word('你', 'nǐ', 'tu, toi'),
    Word('他', 'tā', 'il, lui'),
    Word('她', 'tā', 'elle'),
    Word('我们', 'wǒ men', 'nous'),
    Word('是', 'shì', 'être'),
    Word('的', 'de', 'de (possession)'),
    Word('也', 'yě', 'aussi'),
    Word('都', 'dōu', 'tous, tout'),
    Word('和', 'hé', 'et, avec'),
  ]),
  Unit('Questions', [
    Word('吗', 'ma', 'particule interrogative (oui/non)'),
    Word('呢', 'ne', 'et… ? (particule)'),
    Word('什么', 'shén me', 'quoi, quel'),
    Word('谁', 'shéi', 'qui'),
    Word('哪', 'nǎ', 'lequel'),
    Word('哪儿', 'nǎr', 'où'),
    Word('怎么', 'zěn me', 'comment'),
    Word('怎么样', 'zěn me yàng', 'comment ça va ?'),
    Word('这', 'zhè', 'ceci, ce'),
    Word('那', 'nà', 'cela, ça'),
  ]),
  Unit('Rencontres', [
    Word('叫', 'jiào', 's’appeler'),
    Word('名字', 'míng zi', 'prénom, nom'),
    Word('认识', 'rèn shi', 'connaître (qqn)'),
    Word('朋友', 'péng you', 'ami(e)'),
    Word('同学', 'tóng xué', 'camarade de classe'),
    Word('老师', 'lǎo shī', 'professeur'),
    Word('学生', 'xué sheng', 'élève, étudiant'),
    Word('先生', 'xiān sheng', 'monsieur'),
    Word('小姐', 'xiǎo jie', 'mademoiselle'),
    Word('高兴', 'gāo xìng', 'content(e)'),
  ]),
  Unit('Famille', [
    Word('爸爸', 'bà ba', 'papa'),
    Word('妈妈', 'mā ma', 'maman'),
    Word('儿子', 'ér zi', 'fils'),
    Word('女儿', 'nǚ ér', 'fille'),
    Word('家', 'jiā', 'maison, famille'),
    Word('人', 'rén', 'personne'),
    Word('岁', 'suì', 'ans (âge)'),
    Word('有', 'yǒu', 'avoir, il y a'),
    Word('没有', 'méi yǒu', 'ne pas avoir'),
  ]),
  Unit('Le temps', [
    Word('今天', 'jīn tiān', 'aujourd’hui'),
    Word('明天', 'míng tiān', 'demain'),
    Word('昨天', 'zuó tiān', 'hier'),
    Word('现在', 'xiàn zài', 'maintenant'),
    Word('年', 'nián', 'année'),
    Word('月', 'yuè', 'mois, lune'),
    Word('号', 'hào', 'jour du mois'),
    Word('星期', 'xīng qī', 'semaine'),
    Word('点', 'diǎn', 'heure (h)'),
    Word('分钟', 'fēn zhōng', 'minute'),
    Word('时候', 'shí hou', 'moment'),
  ]),
  Unit('Météo et journée', [
    Word('上午', 'shàng wǔ', 'matinée'),
    Word('中午', 'zhōng wǔ', 'midi'),
    Word('下午', 'xià wǔ', 'après-midi'),
    Word('天气', 'tiān qì', 'météo, temps'),
    Word('冷', 'lěng', 'froid'),
    Word('热', 'rè', 'chaud'),
    Word('下雨', 'xià yǔ', 'pleuvoir'),
  ]),
  Unit('Verbes du quotidien', [
    Word('吃', 'chī', 'manger'),
    Word('喝', 'hē', 'boire'),
    Word('看', 'kàn', 'regarder'),
    Word('看见', 'kàn jiàn', 'voir, apercevoir'),
    Word('听', 'tīng', 'écouter'),
    Word('说', 'shuō', 'parler, dire'),
    Word('读', 'dú', 'lire (à voix haute)'),
    Word('写', 'xiě', 'écrire'),
    Word('做', 'zuò', 'faire'),
    Word('爱', 'ài', 'aimer (amour)'),
    Word('喜欢', 'xǐ huan', 'aimer bien, apprécier'),
    Word('想', 'xiǎng', 'vouloir, penser'),
  ]),
  Unit('Se déplacer', [
    Word('来', 'lái', 'venir'),
    Word('去', 'qù', 'aller'),
    Word('回', 'huí', 'rentrer'),
    Word('在', 'zài', 'être à, se trouver'),
    Word('住', 'zhù', 'habiter'),
    Word('坐', 'zuò', 's’asseoir, prendre (transport)'),
    Word('开', 'kāi', 'ouvrir, conduire'),
    Word('上', 'shàng', 'monter, sur'),
    Word('下', 'xià', 'descendre, sous'),
    Word('出租车', 'chū zū chē', 'taxi'),
    Word('飞机', 'fēi jī', 'avion'),
  ]),
  Unit('Manger et boire', [
    Word('菜', 'cài', 'plat, légume'),
    Word('茶', 'chá', 'thé'),
    Word('水', 'shuǐ', 'eau'),
    Word('米饭', 'mǐ fàn', 'riz cuit'),
    Word('苹果', 'píng guǒ', 'pomme'),
    Word('水果', 'shuǐ guǒ', 'fruit'),
    Word('杯子', 'bēi zi', 'verre, tasse'),
    Word('饭馆', 'fàn guǎn', 'restaurant'),
    Word('东西', 'dōng xi', 'chose, objet'),
  ]),
  Unit('Achats et quantités', [
    Word('买', 'mǎi', 'acheter'),
    Word('钱', 'qián', 'argent'),
    Word('块', 'kuài', 'yuan (monnaie)'),
    Word('商店', 'shāng diàn', 'magasin'),
    Word('大', 'dà', 'grand'),
    Word('小', 'xiǎo', 'petit'),
    Word('多', 'duō', 'beaucoup'),
    Word('少', 'shǎo', 'peu'),
    Word('很', 'hěn', 'très'),
    Word('太', 'tài', 'trop'),
  ]),
  Unit('Lieux', [
    Word('中国', 'Zhōng guó', 'Chine'),
    Word('北京', 'Běi jīng', 'Pékin'),
    Word('学校', 'xué xiào', 'école'),
    Word('医院', 'yī yuàn', 'hôpital'),
    Word('前面', 'qián miàn', 'devant'),
    Word('后面', 'hòu miàn', 'derrière'),
    Word('里', 'lǐ', 'dans, intérieur'),
  ]),
  Unit('Objets du quotidien', [
    Word('电脑', 'diàn nǎo', 'ordinateur'),
    Word('电视', 'diàn shì', 'télévision'),
    Word('电影', 'diàn yǐng', 'film'),
    Word('书', 'shū', 'livre'),
    Word('字', 'zì', 'caractère'),
    Word('桌子', 'zhuō zi', 'table'),
    Word('椅子', 'yǐ zi', 'chaise'),
    Word('衣服', 'yī fu', 'vêtement'),
    Word('本', 'běn', 'classificateur des livres'),
    Word('狗', 'gǒu', 'chien'),
  ]),
  Unit('Travail et études', [
    Word('医生', 'yī shēng', 'médecin'),
    Word('工作', 'gōng zuò', 'travail, travailler'),
    Word('汉语', 'Hàn yǔ', 'chinois (langue)'),
    Word('学习', 'xué xí', 'étudier'),
    Word('睡觉', 'shuì jiào', 'dormir'),
    Word('打电话', 'dǎ diàn huà', 'téléphoner'),
  ]),
  Unit('Petits mots utiles', [
    Word('会', 'huì', 'savoir (faire)'),
    Word('能', 'néng', 'pouvoir'),
    Word('了', 'le', 'particule d’accompli'),
    Word('漂亮', 'piào liang', 'joli(e)'),
    Word('一点儿', 'yì diǎnr', 'un peu'),
    Word('些', 'xiē', 'quelques'),
    Word('个', 'gè', 'classificateur général'),
  ]),
];

final List<Word> kWords = <Word>[for (final u in kUnits) ...u.words];

const kWordsPerLesson = 5;

class Lesson {
  final int id; // numéro global, à partir de 0
  final int unit; // index de l’unité
  final int number; // numéro dans l’unité, à partir de 1
  final List<Word> words;
  const Lesson(this.id, this.unit, this.number, this.words);
}

final List<Lesson> kLessons = _buildLessons();

List<Lesson> _buildLessons() {
  final out = <Lesson>[];
  for (var u = 0; u < kUnits.length; u++) {
    final ws = kUnits[u].words;
    final n = (ws.length / kWordsPerLesson).ceil();
    for (var k = 0; k < n; k++) {
      final a = ws.length * k ~/ n;
      final b = ws.length * (k + 1) ~/ n;
      out.add(Lesson(out.length, u, k + 1, ws.sublist(a, b)));
    }
  }
  return out;
}
