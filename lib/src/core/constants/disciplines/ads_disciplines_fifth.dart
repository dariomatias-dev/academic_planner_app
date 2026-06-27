import 'package:academic_planner/src/core/domain/entities/discipline.dart';

final adsDisciplinesFifth = <Discipline>[
  Discipline(
    id: 52,
    acronym: 'PDM',
    name: 'Programação para Dispositivos Móveis',
    description:
        'Desenvolvimento de aplicações para plataformas móveis, cobrindo '
        'tecnologias sem fio, APIs, integração com Internet e persistência '
        'de dados.',
    period: 5,
    type: 'specific',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 3,
    prerequisites: [25],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'PDM.pdf',
  ),
  Discipline(
    id: 53,
    acronym: 'PJ I',
    name: 'Projeto de Software I',
    description:
        'Concepção de produtos de software sob encomenda, resolução de '
        'conflitos, planejamento de projetos, especificação técnica, '
        'prototipagem, testes e técnicas de projeto centrado no usuário, '
        'com práticas de Extensão.',
    period: 5,
    type: 'professional',
    workload: 100,
    weeklyHours: 6,
    responsibleProfessorId: 11,
    prerequisites: [41],
    prerequisiteFor: [63],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Projeto_de_Software_I.pdf',
  ),
  Discipline(
    id: 55,
    acronym: 'Empreend.',
    name: 'Empreendedorismo',
    description:
        'Aborda os conceitos e práticas do empreendedorismo, criando e '
        'gerindo novos negócios em tecnologia, com foco em ideias inovadoras '
        'e sustentáveis.',
    period: 5,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 13,
    prerequisites: [],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Empreendedorismo_AQmmK77.pdf',
  ),
  Discipline(
    id: 54,
    acronym: 'IA',
    name: 'Mediação de Conflitos',
    description:
        'Explora fundamentos da IA, agentes inteligentes, representação de '
        'conhecimento, solução de problemas e paradigmas de aprendizado de '
        'máquina e suas aplicações.',
    period: 5,
    type: 'specific',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 15,
    prerequisites: [14, 24],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Intelig%C3%AAncia_artificial.pdf',
  ),
  Discipline(
    id: 51,
    acronym: 'DAW III',
    name: 'Desenvolvimento de Aplicações Web III',
    description:
        'Estuda bibliotecas e frameworks para o desenvolvimento web, focando '
        'em interfaces interativas, sistemas back-end escaláveis, componentes '
        'gráficos e boas práticas de desenvolvimento.',
    period: 5,
    type: 'professional',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 2,
    prerequisites: [25, 34],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'DAW_III.pdf',
  ),
];
