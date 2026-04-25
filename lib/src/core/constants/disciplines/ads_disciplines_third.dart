import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';

final adsDisciplinesThird = <DisciplineModel>[
  DisciplineModel(
    id: 35,
    acronym: "MPC",
    name: "Metodologia da Pesquisa Científica",
    description:
        "Desenvolve a capacidade de elaborar trabalhos acadêmicos e científicos na computação, focando em projetos, artigos e monografias, normas ABNT e prevenção de plágio.",
    period: 3,
    type: "basic",
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 5,
    prerequisites: [],
    prerequisiteFor: [],
    coursePlan:
        "https://estudante.ifpb.edu.br/media/cursos/346/disciplina/metodologia.pdf",
  ),
  DisciplineModel(
    id: 31,
    acronym: "EDA",
    name: "Estrutura de Dados e Algoritmos",
    description:
        "Compara algoritmos por notação assintótica e estuda estruturas de dados lineares e não lineares para otimizar a resolução de problemas.",
    period: 3,
    type: "professional",
    workload: 100,
    weeklyHours: 6,
    responsibleProfessorId: 9,
    prerequisites: [25],
    prerequisiteFor: [],
    coursePlan:
        "https://estudante.ifpb.edu.br/media/cursos/346/disciplina/Estrutura_de_Dados_e_Algoritmos.pdf",
  ),
  DisciplineModel(
    id: 32,
    acronym: "BD I",
    name: "Banco de Dados I",
    description:
        "Entendimento e projeto de bancos de dados relacionais, capacitando o aluno em terminologia, etapas de projeto, estruturas normalizadas e SQL.",
    period: 3,
    type: "professional",
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 11,
    prerequisites: [],
    prerequisiteFor: [42, 43],
    coursePlan:
        "https://estudante.ifpb.edu.br/media/cursos/346/disciplina/Banco_de_Dados_I.pdf",
  ),
  DisciplineModel(
    id: 34,
    acronym: "DAW I",
    name: "Desenvolvimento de Aplicações Web I",
    description:
        "Apresenta conceitos e linguagens para construção de sites no lado cliente, estruturando, formatando e definindo esquemas de documento em linguagem de marcação, utilizando scripts, manipulando elementos DOM e aplicando expressões regulares.",
    period: 3,
    type: "professional",
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 12,
    prerequisites: [],
    prerequisiteFor: [51, 64],
    coursePlan:
        "https://estudante.ifpb.edu.br/media/cursos/346/disciplina/DAW_I.pdf",
  ),
  DisciplineModel(
    id: 33,
    acronym: "PP",
    name: "Padrões de Projeto",
    description:
        "Capacita os alunos a identificar, compreender e aplicar padrões de projeto para construir softwares flexíveis, reutilizáveis e escaláveis, seguindo boas práticas de desenvolvimento.",
    period: 3,
    type: "professional",
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 2,
    prerequisites: [25],
    prerequisiteFor: [],
    coursePlan:
        "https://estudante.ifpb.edu.br/media/cursos/346/disciplina/padr%C3%B5es_de_projeto.pdf",
  ),
];
