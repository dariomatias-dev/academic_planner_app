import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';

final adsDisciplinesFirst = <DisciplineModel>[
  DisciplineModel(
    id: 15,
    acronym: 'Intr. Comp.',
    name: 'Introdução à Computação',
    description:
        'Estudo dos componentes de um computador, funcionamento e '
        'representação digital da informação, e introdução à arquitetura '
        'de computadores.',
    period: 1,
    type: 'professional',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 1,
    prerequisites: [],
    prerequisiteFor: [26, 45],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Introdu%C3%A7%C3%A3o_%C3%A0_computa%C3%A7%C3%A3o.pdf',
  ),
  DisciplineModel(
    id: 14,
    acronym: 'Algo',
    name: 'Algoritmos e Lógica de Programação',
    description:
        'Estudo da lógica de programação e algoritmos, focando na análise '
        'e resolução de problemas e implementação de rotinas computacionais.',
    period: 1,
    type: 'professional',
    workload: 134,
    weeklyHours: 8,
    responsibleProfessorId: 2,
    prerequisites: [],
    prerequisiteFor: [21, 25, 54],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'ALgoritmos_e_L%C3%B3gica_de_Programa%C3%A7%C3%A3o.pdf',
  ),
  DisciplineModel(
    id: 11,
    acronym: 'MAC',
    name: 'Matemática Aplicada à Computação',
    description:
        'Estudo da lógica e conceitos matemáticos, incluindo matrizes, '
        'teoria dos conjuntos, relações, funções e recursão, e suas '
        'aplicações na computação.',
    period: 1,
    type: 'basic',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 4,
    prerequisites: [],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/mat.pdf',
  ),
  DisciplineModel(
    id: 13,
    acronym: 'LPT I',
    name: 'Práticas de Leitura e Produção de Textos I',
    description:
        'Desenvolve leitura e produção textual, conectando temas do curso '
        'a questões sociais e de direitos humanos, aprimorando comunicação '
        'técnica.',
    period: 1,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 5,
    prerequisites: [],
    prerequisiteFor: [23],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'PLPT_I.pdf',
  ),
  DisciplineModel(
    id: 12,
    acronym: 'Inglês I',
    name: 'Inglês Instrumental I',
    description:
        'Desenvolvimento da leitura em inglês, focando na compreensão '
        'textual, aquisição de vocabulário e aplicação crítica em contextos '
        'acadêmicos e profissionais, com textos de '
        'computação e temas variados.',
    period: 1,
    type: 'basic',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 6,
    prerequisites: [],
    prerequisiteFor: [22],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Ingl%C3%AAs_I.pdf',
  ),
];
