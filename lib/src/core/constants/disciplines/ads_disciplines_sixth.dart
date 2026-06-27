import 'package:academic_planner/src/core/domain/entities/discipline.dart';

final adsDisciplinesSixth = <Discipline>[
  Discipline(
    id: 63,
    acronym: 'PJ II',
    name: 'Projeto de Software II',
    description:
        'Continuação de Projeto de Software I, focando na entrega de um '
        'product funcional, gestão de equipes, CI/CD, documentação e '
        'apresentação de projeto final.',
    period: 6,
    type: 'professional',
    workload: 100,
    weeklyHours: 6,
    responsibleProfessorId: 5,
    prerequisites: [53],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Projeto2.pdf',
  ),
  Discipline(
    id: 64,
    acronym: 'TT',
    name: 'Técnicas de Testes',
    description:
        'Estuda princípios, conceitos e processos de teste de software, '
        'tipos de teste (unidade, integração, sistema, aceitação, etc.), '
        'testes de caixa branca e preta, TDD e gestão de testes.',
    period: 6,
    type: 'professional',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 12,
    prerequisites: [34, 43],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Testes.pdf',
  ),
  Discipline(
    id: 62,
    acronym: 'GCM',
    name: 'Gerência de Configuração e Mudanças',
    description:
        'Estudo do ciclo de vida de produtos e artefatos de software, com '
        'foco em gerenciamento de configurações, controle de mudanças, '
        'ferramentas e integração contínua.',
    period: 6,
    type: 'specific',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 2,
    prerequisites: [43],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'GERENCIA-CONFIGURACAO-CORRIGIDO.pdf',
  ),
  Discipline(
    id: 61,
    acronym: 'Segurança',
    name: 'Segurança da Informação',
    description:
        'Estuda conceitos, riscos e mecanismos de defesa em segurança da '
        'informação, focando em criptografia, redes e programação segura.',
    period: 6,
    type: 'specific',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 7,
    prerequisites: [26, 43],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Seguranca.pdf',
  ),
  Discipline(
    id: 65,
    acronym: 'CD',
    name: 'Ciência de Dados',
    description:
        'Introdução à Ciência de Dados, abrangendo coleta, processamento, '
        'análise, modelagem e visualização de dados, além de fundamentos '
        'de Machine Learning e KDD.',
    period: 6,
    type: 'elective',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 3,
    prerequisites: [31, 32, 54],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Ci%C3%AAncia_de_Dados.pdf',
  ),
  Discipline(
    id: 66,
    acronym: 'Jogos Digitais',
    name: 'Jogos Digitais',
    description:
        'Estudo e aplicação de conceitos, técnicas e ferramentas para '
        'projetar, desenvolver, testar e implantar jogos digitais 2D e 3D '
        'em diversas plataformas, incluindo gerenciamento de projetos.',
    period: 6,
    type: 'elective',
    workload: 67,
    weeklyHours: 4,
    responsibleProfessorId: 2,
    prerequisites: [25, 26],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'jogos_digitais.pdf',
  ),
  Discipline(
    id: 67,
    acronym: 'LIBRAS',
    name: 'LIBRAS (Língua Brasileira de Sinais)',
    description:
        'Introdução à Língua Brasileira de Sinais, abrangendo seus '
        'aspectos gramaticais, culturais e a relação com a identidade Surda.',
    period: 6,
    type: 'elective',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 0,
    prerequisites: [],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Libras.pdf',
  ),
  Discipline(
    id: 68,
    acronym: 'IHC',
    name: 'Interação Humano-Computador',
    description:
        'Capacita os alunos a aplicar princípios de IHC no projeto, '
        'desenvolvimento e avaliação de interfaces usáveis, acessíveis, '
        'eficientes e que proporcionem boa experiência ao usuário.',
    period: 6,
    type: 'elective',
    workload: 33,
    weeklyHours: 2,
    responsibleProfessorId: 2,
    prerequisites: [],
    prerequisiteFor: [],
    coursePlan:
        'https://estudante.ifpb.edu.br/media/cursos/346/disciplina/'
        'Intera%C3%A7%C3%A3o_humano.pdf',
  ),
];
