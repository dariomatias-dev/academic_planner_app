import 'package:academic_planner/src/features/disciplines/domain/entities/discipline.dart';

final adsDisciplinesSecond = <Discipline>[
  Discipline(
    id: 25,
    acronym: 'POO',
    name: 'Programação Orientada a Objetos',
    description:
        'Aprender os conceitos e aplicar a programação orientada a objetos '
        'para desenvolver softwares modulares, reutilizáveis e robustos.',
    period: 2,
    type: 'professional',
    workload: 134,
    weeklyHours: 8,
    responsibleProfessorId: 7,
    prerequisites: [14],
    prerequisiteFor: [31, 33, 41, 43, 51, 52],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'POO_HQ1Xogk.pdf',
  ),
  Discipline(
    id: 24,
    acronym: 'PE',
    name: 'Probabilidade e Estatística',
    description:
        'Capacita o aluno a usar métodos estatísticos para sumarizar, '
        'calcular e analisar informações, da análise exploratória de dados '
        'à inferência estatística e testes de hipóteses, '
        'para tomada de decisões.',
    period: 2,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 4,
    prerequisites: [],
    prerequisiteFor: [54],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'probabilidade.pdf',
  ),
  Discipline(
    id: 23,
    acronym: 'LPT II',
    name: 'Práticas de Leitura e Produção de Textos II',
    description:
        'Aprofunda a leitura e produção de textos, conectando temas técnicos '
        'a questões sociais e ambientais, aprimorando '
        'a comunicação profissional.',
    period: 2,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 8,
    prerequisites: [13],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'PLPT_II.pdf',
  ),
  Discipline(
    id: 26,
    acronym: 'Redes',
    name: 'Introdução a Redes de Computadores',
    description:
        'Introdução a redes de computadores, abrangendo motivações, '
        'protocolos, arquiteturas, identificação de componentes, classificação '
        'e diferenciação entre modelos OSI/ISO e TCP/IP.',
    period: 2,
    type: 'professional',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 9,
    prerequisites: [15],
    prerequisiteFor: [61],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'introdu%C3%A7%C3%A3o_a_rede_de_computadores.pdf',
  ),
  Discipline(
    id: 22,
    acronym: 'Inglês II',
    name: 'Inglês Instrumental II',
    description:
        'Continua o desenvolvimento da leitura em inglês, aperfeiçoando a '
        'compreensão textual e vocabulário, com foco em textos de computação '
        'e temas transversais para uso crítico e reflexivo em estudos e vida '
        'profissional.',
    period: 2,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 6,
    prerequisites: [12],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Ingl%C3%AAs_II.pdf',
  ),
  Discipline(
    id: 21,
    acronym: 'LTG',
    name: 'Lógica e Teoria dos Grafos',
    description:
        'Introdução à teoria dos grafos e lógica, focando na resolução de '
        'problemas com algoritmos para caminhos e árvores.',
    period: 2,
    type: 'professional',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 10,
    prerequisites: [14],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'L%C3%B3gica_e_Teoria_dos_Grafos.pdf',
  ),
];
