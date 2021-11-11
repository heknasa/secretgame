List<String> questions = [
  'Siapakah presiden pertama Indonesia?',
  'Hasil dari 350 x 24...',
  'Apa arti kata "hubris"? (bahasa Inggris)',
  'Apakah bahasa native dari Android?',
  'Siapakah pembuat web-app Sudah Muda?'
];

List<String> alphabets = ['A', 'B', 'C', 'D'];

List<List<String>> choices = [
  ['Soekarno', 'Soeharto', 'Habibie', 'Gus Dur'],
  ['8.400', '8.200', '8.600', '8.500'],
  ['mewah', 'ceroboh', 'keangkuhan', 'ketidakpedulian'],
  ['Javascript', 'Java', 'Inggris', 'Dart'],
  ['Anggoran', 'Si Narsis', 'Bang Ganteng', 'Salam dari Binjai']
];

List<String> answers = [
  'Soekarno',
  '8.400',
  'keangkuhan',
  'Java',
  'Anggoran'
];

void shuffleChoices(int index) {
  choices[index].shuffle();
}