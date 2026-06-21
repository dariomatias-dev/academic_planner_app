import 'package:academic_planner/src/features/disciplines/domain/entities/discipline.dart';

final adsDisciplinesFourth = <Discipline>[
  Discipline(
    id: 44,
    acronym: 'Intr. Admin',
    name: 'Introdução à Administração',
    description:
        'Apresenta os princípios básicos da administração, funções e processo '
        'administrativo, papéis do gestor, áreas funcionais da empresa e a '
        'importância da sustentabilidade e responsabilidade socioambiental.',
    period: 4,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 13,
    prerequisites: [],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'adm.pdf',
  ),
  Discipline(
    id: 42,
    acronym: 'BD II',
    name: 'Banco de Dados II',
    description:
        'Estuda modelos e tecnologias de bancos de dados não convencionais, '
        'abordando armazenamento, manipulação de dados, e as limitações do '
        'modelo relacional.',
    period: 4,
    type: 'specific',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 11,
    prerequisites: [32],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Banco_de_dados_II.pdf',
  ),
  Discipline(
    id: 45,
    acronym: 'SO',
    name: 'Sistemas Operacionais',
    description:
        'Estuda princípios, funcionamento, gerenciamento de recursos, e '
        'interação com hardware de sistemas operacionais.',
    period: 4,
    type: 'professional',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 10,
    prerequisites: [15],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Sistemas_Operacionais.pdf',
  ),
  Discipline(
    id: 41,
    acronym: 'APS',
    name: 'Análise e Projeto de Sistemas',
    description:
        'Metodologias e técnicas para análise de requisitos, modelagem e '
        'projeto de sistemas de software, incluindo UML.',
    period: 4,
    type: 'professional',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 10,
    prerequisites: [25],
    prerequisiteFor: [53],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'aps.pdf',
  ),
  Discipline(
    id: 46,
    acronym: 'RHT',
    name: 'Relações Humanas no Trabalho',
    description:
        'Aborda comportamento organizacional, liderança, cultura, RH e '
        'relações étnico-raciais no trabalho.',
    period: 4,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 13,
    prerequisites: [],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'rht.pdf',
  ),
  Discipline(
    id: 43,
    acronym: 'DAW II',
    name: 'Desenvolvimento de Aplicações Web II',
    description:
        'Desenvolvimento de aplicações web dinâmicas com tecnologias back-end, '
        'integração de bancos de dados, conceitos HTTP, arquiteturas web e '
        'boas práticas de segurança.',
    period: 4,
    type: 'professional',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 12,
    prerequisites: [25, 32],
    prerequisiteFor: [61, 62, 64],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'DAW_II.pdf',
  ),
  Discipline(
    id: 47,
    acronym: 'STI',
    name: 'Sociedade e Tecnologia da Informação',
    description:
        'Analisa o impacto social, ético e cultural da TI na sociedade '
        'contemporânea, incluindo globalização, inclusão digital, privacidade '
        'e o futuro do trabalho.',
    period: 4,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 14,
    prerequisites: [],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'sociologia.pdf',
  ),
];
