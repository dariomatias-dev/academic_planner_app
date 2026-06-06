import 'package:academic_planner/src/features/teacher/data/models/teacher_model.dart';

const teachers = <TeacherModel>[
  TeacherModel(
    id: 1,
    name: "Marcos Vinicius Andrade Lima",
    lattes: "http://lattes.cnpq.br/0000000000000001",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Engenharia Civil",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2000 - 2002",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1999 - 2004",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1997 - 2000",
      ),
    ],
  ),
  TeacherModel(
    id: 2,
    name: "Fernanda Costa Ribeiro",
    lattes: "http://lattes.cnpq.br/0000000000000002",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Engenharia de Materiais (em andamento)",
        institution: "Instituto Politécnico Aurora (IPA)",
        period: "2019 - 2023",
      ),
      TeacherFormationModel(
        degree: "Mestrado Profissional em Artes Cênicas",
        institution: "Instituto Politécnico Aurora (IPA)",
        period: "2015 - 2020",
      ),
      TeacherFormationModel(
        degree: "Graduação em Farmácia",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1994 - 1995",
      ),
      TeacherFormationModel(
        degree: "Curso técnico/profissionalizante",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2015 - 2017",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Introdução à Sustentabilidade",
        institution: "Instituto Superior Horizonte (ISH)",
        period: "2000 - 2002",
        workload: "372h",
      ),
    ],
  ),
  TeacherModel(
    id: 3,
    name: "Rodrigo Almeida Nogueira",
    lattes: "http://lattes.cnpq.br/0000000000000003",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Engenharia Civil",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2011 - 2014",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1999 - 2004",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2005 - 2009",
      ),
    ],
  ),
  TeacherModel(
    id: 4,
    name: "Patricia Souza Cavalcante",
    lattes: "http://lattes.cnpq.br/0000000000000004",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Administração",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2012 - 2014",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Educação Física",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1990 - 1993",
      ),
      TeacherFormationModel(
        degree: "Graduação em Ciências Sociais",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1990 - 1994",
      ),
    ],
  ),
  TeacherModel(
    id: 5,
    name: "Camila Ferreira Nascimento",
    lattes: "http://lattes.cnpq.br/0000000000000005",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Engenharia Civil",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2011 - 2014",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1999 - 2004",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1994 - 1998",
      ),
    ],
  ),
  TeacherModel(
    id: 6,
    name: "Diego Martins Carvalho",
    lattes: "http://lattes.cnpq.br/0000000000000006",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Biologia",
        institution: "Instituto Superior do Vale (ISV)",
        period: "2011 - 2015",
      ),
      TeacherFormationModel(
        degree: "Graduação em Estatística",
        institution: "Universidade Regional do Litoral (URL)",
        period: "1991 - 1992",
      ),
    ],
  ),
  TeacherModel(
    id: 7,
    name: "Juliana Pereira Rocha",
    lattes: "http://lattes.cnpq.br/0000000000000007",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2022 - 2023",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1998 - 2002",
      ),
    ],
  ),
  TeacherModel(
    id: 8,
    name: "Thiago Barbosa Correia",
    lattes: "http://lattes.cnpq.br/0000000000000008",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Administração",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2000 - 2002",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Engenharia Civil",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2001 - 2004",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2011 - 2014",
      ),
    ],
  ),
  TeacherModel(
    id: 9,
    name: "Larissa Gomes Teixeira",
    lattes: "http://lattes.cnpq.br/0000000000000009",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Matemática Aplicada",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1999 - 2004",
      ),
      TeacherFormationModel(
        degree: "Graduação em Engenharia de Materiais",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1991 - 1992",
      ),
    ],
  ),
  TeacherModel(
    id: 10,
    name: "Eduardo Santos Monteiro",
    lattes: "http://lattes.cnpq.br/0000000000000010",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Jornalismo",
        institution: "Centro Universitário Aurora (CUA)",
        period: "1994 - 1998",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Universitário Aurora (CUA)",
        period: "1985 - 1989",
      ),
      TeacherFormationModel(
        degree: "Graduação em Farmácia",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "1995 - 1996",
      ),
    ],
  ),
  TeacherModel(
    id: 11,
    name: "Beatriz Lima Cordeiro",
    lattes: "http://lattes.cnpq.br/0000000000000011",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Sistemas de Informação",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2004 - 2008",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2000 - 2002",
      ),
      TeacherFormationModel(
        degree: "Graduação em Engenharia de Materiais",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1993 - 1994",
      ),
    ],
  ),
  TeacherModel(
    id: 12,
    name: "Gustavo Henrique Vasconcelos",
    lattes: "http://lattes.cnpq.br/0000000000000012",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1999 - 2004",
      ),
      TeacherFormationModel(
        degree: "Graduação em Farmácia",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2016 - 2021",
      ),
    ],
  ),
  TeacherModel(
    id: 13,
    name: "Renata Alves Fontoura",
    lattes: "http://lattes.cnpq.br/0000000000000013",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2015 - 2020",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2013 - 2018",
      ),
    ],
  ),
  TeacherModel(
    id: 14,
    name: "Vinicius Cardoso Duarte",
    lattes: "http://lattes.cnpq.br/0000000000000014",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Engenharia Civil",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2007 - 2011",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2015 - 2020",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2013 - 2018",
      ),
    ],
  ),
  TeacherModel(
    id: 15,
    name: "Amanda Ribeiro Siqueira",
    lattes: "http://lattes.cnpq.br/0000000000000015",
    academicBackground: [
      TeacherFormationModel(
        degree: "Graduação em Ciências Sociais",
        institution: "Centro Universitário Novo Horizonte (CUNH)",
        period: "2010 - 2014",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Mediação de Conflitos",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2011 - 2015",
        workload: "720h",
      ),
    ],
  ),
  TeacherModel(
    id: 16,
    name: "Felipe Augusto Moreira",
    lattes: "http://lattes.cnpq.br/0000000000000016",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Artes Cênicas",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "2007 - 2010",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Filosofia",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2004 - 2006",
      ),
      TeacherFormationModel(
        degree: "Graduação em Física",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2005 - 2009",
      ),
    ],
  ),
  TeacherModel(
    id: 17,
    name: "Isabela Martins Freitas",
    lattes: "http://lattes.cnpq.br/0000000000000017",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado Profissional em Estatística",
        institution: "Faculdade Pioneira (FP)",
        period: "1997 - 2002",
      ),
      TeacherFormationModel(
        degree: "Graduação em Física",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1996 - 1998",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Acessibilidade e Inclusão",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2003 - 2006",
        workload: "420h",
      ),
      TeacherSpecializationModel(
        name: "Formação em Tutoria Acadêmica",
        institution: "Centro Universitário Vale do Sol (CUVS)",
        period: "2003 - 2006",
        workload: "360h",
      ),
    ],
  ),
  TeacherModel(
    id: 18,
    name: "Rafael Nogueira Peixoto",
    lattes: "http://lattes.cnpq.br/0000000000000018",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2000 - 2002",
      ),
      TeacherFormationModel(
        degree: "Graduação em Engenharia de Produção",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "1993 - 1998",
      ),
      TeacherFormationModel(
        degree: "Graduação em Geografia",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1998 - 2002",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Planejamento Educacional",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2003 - 2007",
        workload: "510h",
      ),
    ],
  ),
  TeacherModel(
    id: 19,
    name: "Vanessa Castro Lopes",
    lattes: "http://lattes.cnpq.br/0000000000000019",
    academicBackground: [
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "1990 - 1993",
      ),
      TeacherFormationModel(
        degree: "Graduação em Biologia",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1992 - 1993",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Metodologias Ativas de Ensino",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "2013 - 2017",
        workload: "450h",
      ),
    ],
  ),
  TeacherModel(
    id: 20,
    name: "Bruno Cesar Andrade",
    lattes: "http://lattes.cnpq.br/0000000000000020",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2004 - 2008",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Estatística",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1990 - 1994",
      ),
      TeacherFormationModel(
        degree: "Graduação em Biologia",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2011 - 2014",
      ),
    ],
    complementaryEducation: [
      TeacherComplementaryFormationModel(
        name: "Gestão de Equipes e Processos",
        institution: "Centro Universitário Aurora (CUA)",
        year: "2003 - 2007",
        workload: "N/A",
      ),
    ],
  ),
  TeacherModel(
    id: 21,
    name: "Priscila Farias Bezerra",
    lattes: "http://lattes.cnpq.br/0000000000000021",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Engenharia Civil",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2003 - 2006",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1987 - 1989",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1994 - 1995",
      ),
    ],
  ),
  TeacherModel(
    id: 22,
    name: "Leonardo Matos Guedes",
    lattes: "http://lattes.cnpq.br/0000000000000022",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Sistemas de Informação",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1988 - 1993",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Geografia",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1990 - 1993",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2011 - 2015",
      ),
    ],
    postDoctorate: [
      TeacherFormationModel(
        degree: "Pós-Doutorado",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2003 - 2007",
      ),
    ],
  ),
  TeacherModel(
    id: 23,
    name: "Simone Araujo Vieira",
    lattes: "http://lattes.cnpq.br/0000000000000023",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Farmácia",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1995 - 1999",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Biologia",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2011 - 2013",
      ),
      TeacherFormationModel(
        degree: "Graduação em Farmácia",
        institution: "Instituto Técnico Rio Claro (ITRC)",
        period: "1985 - 1987",
      ),
      TeacherFormationModel(
        degree: "Graduação em Farmácia",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2013 - 2018",
      ),
      TeacherFormationModel(
        degree: "Graduação em Matemática Aplicada",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2005 - 2009",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Metodologias Ativas de Ensino",
        institution: "Centro Universitário Vale do Sol (CUVS)",
        period: "2004 - 2008",
        workload: "360h",
      ),
      TeacherSpecializationModel(
        name: "Práticas Colaborativas em Sala de Aula",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2004 - 2006",
        workload: "390h",
      ),
    ],
    postDoctorate: [
      TeacherFormationModel(
        degree: "Pós-Doutorado",
        institution: "Instituto Superior Horizonte (ISH)",
        period: "2011 - 2015",
      ),
    ],
  ),
  TeacherModel(
    id: 24,
    name: "Daniel Rocha Meireles",
    lattes: "http://lattes.cnpq.br/0000000000000024",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Química",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1995 - 1999",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Educação",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "2022 - 2023",
      ),
      TeacherFormationModel(
        degree: "Graduação em História",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2003 - 2007",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1994 - 1995",
      ),
    ],
  ),
  TeacherModel(
    id: 25,
    name: "Tatiane Correia Sales",
    lattes: "http://lattes.cnpq.br/0000000000000025",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2000 - 2002",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2012 - 2013",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Ferramentas Digitais para Educação",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2001 - 2006",
        workload: "390h",
      ),
    ],
  ),
  TeacherModel(
    id: 26,
    name: "Marcelo Dantas Coelho",
    lattes: "http://lattes.cnpq.br/0000000000000026",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Engenharia de Materiais",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2011 - 2014",
      ),
      TeacherFormationModel(
        degree: "Graduação em Artes Cênicas",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1993 - 1994",
      ),
    ],
  ),
  TeacherModel(
    id: 27,
    name: "Aline Sousa Barreto",
    lattes: "http://lattes.cnpq.br/0000000000000027",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em História",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "1999 - 2003",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "1985 - 1987",
      ),
      TeacherFormationModel(
        degree: "Graduação em Engenharia de Materiais",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2010 - 2014",
      ),
    ],
    postDoctorate: [
      TeacherFormationModel(
        degree: "Pós-Doutorado",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "2020 - 2023",
      ),
    ],
  ),
  TeacherModel(
    id: 28,
    name: "Igor Pimentel Cavalcanti",
    lattes: "http://lattes.cnpq.br/0000000000000028",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Sistemas de Informação",
        institution: "Instituto Politécnico Aurora (IPA)",
        period: "2009 - 2011",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Estatística",
        institution: "Instituto Politécnico Aurora (IPA)",
        period: "2003 - 2007",
      ),
      TeacherFormationModel(
        degree: "Graduação em Farmácia",
        institution: "Instituto Politécnico Aurora (IPA)",
        period: "1998 - 2000",
      ),
    ],
  ),
  TeacherModel(
    id: 29,
    name: "Cristina Melo Andrade",
    lattes: "http://lattes.cnpq.br/0000000000000029",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado Profissional em Engenharia de Materiais",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2009 - 2011",
      ),
      TeacherFormationModel(
        degree: "Graduação em Engenharia Civil",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "1988 - 1993",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Gestão de Projetos Educacionais",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "1990 - 1993",
        workload: "390h",
      ),
    ],
  ),
  TeacherModel(
    id: 30,
    name: "Fabio Henrique Lacerda",
    lattes: "http://lattes.cnpq.br/0000000000000030",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Filosofia",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2012 - 2014",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Física",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1990 - 1993",
      ),
      TeacherFormationModel(
        degree: "Graduação em Sistemas de Informação",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1998 - 2000",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Centro Universitário Novo Horizonte (CUNH)",
        period: "1989 - 1991",
      ),
    ],
  ),
  TeacherModel(
    id: 31,
    name: "Eduardo Santos Monteiro",
    lattes: "http://lattes.cnpq.br/0000000000000010",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Matemática Aplicada",
        institution: "Centro Universitário Aurora (CUA)",
        period: "1994 - 1998",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Química",
        institution: "Faculdade Boa Vista (FBV)",
        period: "2000 - 2002",
      ),
      TeacherFormationModel(
        degree: "Graduação em Pedagogia",
        institution: "Instituto Vale Verde (IVV)",
        period: "1990 - 1994",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Gestão de Equipes e Processos",
        institution: "Instituto Politécnico Aurora (IPA)",
        period: "2003 - 2007",
        workload: "360h",
      ),
      TeacherSpecializationModel(
        name: "Práticas Colaborativas em Sala de Aula",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "2001 - 2004",
        workload: "360h",
      ),
    ],
  ),
  TeacherModel(
    id: 32,
    name: "Michele Torres Aguiar",
    lattes: "http://lattes.cnpq.br/0000000000000032",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Educação",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "1993 - 1997",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Estatística",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1999 - 2004",
      ),
      TeacherFormationModel(
        degree: "Graduação em Biologia",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1996 - 2000",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Planejamento Educacional",
        institution: "Universidade Comunitária Bela Vista (UCBV)",
        period: "2001 - 2006",
        workload: "680h",
      ),
      TeacherSpecializationModel(
        name: "Fundamentos de Análise de Dados",
        institution: "Instituto Superior do Vale (ISV)",
        period: "1995 - 1999",
        workload: "380h",
      ),
    ],
  ),
  TeacherModel(
    id: 33,
    name: "Alexandre Nunes Pontes",
    lattes: "http://lattes.cnpq.br/0000000000000033",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado Profissional em Física",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2003 - 2007",
      ),
      TeacherFormationModel(
        degree: "Graduação em Ciências Sociais",
        institution: "Instituto Vale Verde (IVV)",
        period: "1988 - 1993",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Comunicação Institucional",
        institution: "Universidade Comunitária Bela Vista (UCBV)",
        period: "2005 - 2006",
        workload: "405h",
      ),
    ],
  ),
  TeacherModel(
    id: 34,
    name: "Sabrina Diniz Marques",
    lattes: "http://lattes.cnpq.br/0000000000000034",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em História",
        institution: "Instituto Técnico Rio Claro (ITRC)",
        period: "2011 - 2014",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Engenharia Elétrica",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1987 - 1989",
      ),
      TeacherFormationModel(
        degree: "Graduação em Ciências Sociais",
        institution: "Instituto Vale Verde (IVV)",
        period: "2005 - 2009",
      ),
      TeacherFormationModel(
        degree: "Graduação em Jornalismo",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2005 - 2009",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Planejamento Educacional",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2001 - 2006",
        workload: "710h",
      ),
    ],
  ),
  TeacherModel(
    id: 35,
    name: "Leonardo Matos Guedes",
    lattes: "http://lattes.cnpq.br/0000000000000022",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Sistemas de Informação",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1988 - 1993",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Geografia",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "1990 - 1993",
      ),
      TeacherFormationModel(
        degree:
            "Graduação em Licenciatura e Bacharelado em Ciências Biológicas",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2011 - 2015",
      ),
    ],
    postDoctorate: [
      TeacherFormationModel(
        degree: "Pós-Doutorado",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2003 - 2007",
      ),
    ],
  ),
  TeacherModel(
    id: 36,
    name: "Wesley Batista Fagundes",
    lattes: "http://lattes.cnpq.br/0000000000000036",
    academicBackground: [
      TeacherFormationModel(
        degree: "Mestrado em Sistemas de Informação",
        institution: "Faculdade Estrela do Norte (FEN)",
        period: "2015 - 2020",
      ),
      TeacherFormationModel(
        degree: "Graduação em História",
        institution: "Faculdade Boa Vista (FBV)",
        period: "1989 - 1991",
      ),
      TeacherFormationModel(
        degree: "Graduação em Engenharia Civil",
        institution: "Universidade Metropolitana do Sul (UMS)",
        period: "2011 - 2014",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Comunicação Institucional",
        institution: "Instituto Superior do Vale (ISV)",
        period: "2013 - 2017",
        workload: "480h",
      ),
    ],
  ),
  TeacherModel(
    id: 37,
    name: "Carla Regina Amaral",
    lattes: "http://lattes.cnpq.br/0000000000000037",
    academicBackground: [
      TeacherFormationModel(
        degree:
            "Mestrado Profissional em Propriedade Intelectual e Transferência de Tecnologia para Inovação (PROFNIT)",
        institution: "Centro Universitário Novo Horizonte (CUNH)",
        period: "2001 - 2003",
      ),
      TeacherFormationModel(
        degree: "Graduação em Filosofia",
        institution: "Faculdade Nova Aliança (FNA)",
        period: "2011 - 2015",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Formação em Tutoria Acadêmica",
        institution: "Faculdade Pioneira (FP)",
        period: "2010 - 2013",
        workload: "360h",
      ),
    ],
  ),
  TeacherModel(
    id: 38,
    name: "Ricardo Bastos Feitosa",
    lattes: "http://lattes.cnpq.br/0000000000000038",
    academicBackground: [
      TeacherFormationModel(
        degree: "Doutorado em Sistemas de Informação",
        institution: "Centro Educacional Serra Alta (CESA)",
        period: "1992 - 1993",
      ),
      TeacherFormationModel(
        degree: "Mestrado em Ciência da Computação",
        institution: "Centro Universitário Novo Horizonte (CUNH)",
        period: "1985 - 1987",
      ),
      TeacherFormationModel(
        degree: "Graduação em Farmácia",
        institution: "Universidade Regional do Litoral (URL)",
        period: "2013 - 2018",
      ),
    ],
    postGraduation: [
      TeacherSpecializationModel(
        name: "Fundamentos de Análise de Dados",
        institution: "Universidade Regional do Litoral (URL)",
        period: "1997 - 2002",
        workload: "420h",
      ),
    ],
  ),
];
