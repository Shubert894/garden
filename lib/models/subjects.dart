class Subject {
  String title;

  String text;

  List<SubSubject> subSubjects = [];

  Subject({this.title = '', this.text = '', this.subSubjects = const []});
}

class SubSubject {
  String title;

  String text;

  SubSubject({this.title = '', this.text = ''});
}

List<Subject> rSubjects = [
  Subject(
      title: 'Physical characteristics',
      subSubjects: rSubSubjects,
      text:
          'Aluminium (aluminum in American and Canadian English) is a chemical element with the symbol Al and atomic number 13. Aluminium has a density lower than those of other common metals, at approximately one third that of steel. It has a great affinity towards oxygen, and forms a protective layer of oxide on the surface when exposed to air. Aluminium visually resembles silver, both in its color and in its great ability to reflect light. It is soft, non-magnetic and ductile. It has one stable isotope, 27Al; this isotope is very common, making aluminium the twelfth most common element in the Universe. The radioactivity of 26Al is used in radiodating.'),
  Subject(
      title: 'Chemistry',
      subSubjects: rSubSubjects,
      text:
          'Aluminium combines characteristics of pre- and post-transition metals. Since it has few available electrons for metallic bonding, like its heavier group 13 congeners, it has the characteristic physical properties of a post-transition metal, with longer-than-expected interatomic distances.[15] Furthermore, as Al3+ is a small and highly charged cation, it is strongly polarizing and bonding in aluminium compounds tends towards covalency;[29] this behavior is similar to that of beryllium (Be2+), and the two display an example')
];

List<SubSubject> rSubSubjects = [
  SubSubject(
      title: 'Isotopes',
      text:
          'Of aluminium isotopes, only 27 Al is stable. This situation is common for elements with an odd atomic number.[b] It is the only primordial aluminium isotope, i.e. the only one that has existed on Earth in its current form since the formation of the planet. Nearly all aluminium on Earth is present as this isotope, which makes it a mononuclidic element and means that its standard atomic weight is virtually the same as that of the isotope. This makes aluminium very useful in nuclear magnetic resonance (NMR), as its single stable isotope has a high NMR sensitivity.[6] The standard atomic weight of aluminium is low in comparison with many other metals,[c] which has consequences for the elements properties (see below). All other isotopes of aluminium are radioactive. The most stable of these is 26Al: while it was present along with stable 27Al in the interstellar medium from which the Solar System formed, having been produced by stellar nucleosynthesis as well, its half-life is only 717,000 years and therefore a detectable amount has not survived since the formation of the planet.[7] However, minute traces of 26Al are produced from argon in the atmosphere by spallation caused by cosmic ray protons. The ratio of 26Al to 10Be has been used for radiodating of geological processes over 105 to 106 year time scales, in particular transport, deposition, sediment storage, burial times, and erosion.[8] Most meteorite scientists believe that the energy released by the decay of 26Al was responsible for the melting and differentiation of some asteroids after their formation 4.55 billion years ago.[9] The remaining isotopes of aluminium, with mass numbers ranging from 22 to 43, all have half-lives well under an hour. Three metastable states are known, all with half-lives under a minute.'),
  SubSubject(
      title: 'Electron Shell',
      text:
          'An aluminium atom has 13 electrons, arranged in an electron configuration of [Ne] 3s2 3p1,[10] with three electrons beyond a stable noble gas configuration. Accordingly, the combined first three ionization energies of aluminium are far lower than the fourth ionization energy alone.[11] Such an electron configuration is shared with the other well-characterized members of its group, boron, gallium, indium, and thallium; it is also expected for nihonium. Aluminium can relatively easily surrender its three outermost electrons in many chemical reactions (see below). The electronegativity of aluminium is 1.61 (Pauling scale).[12]'),
];
