import 'package:academic_planner/src/features/teacher/domain/entities/teacher.dart';

const teachers = <Teacher>[
  Teacher(
    id: 1,
    name: 'Marcos Vinicius Andrade Lima',
    lattes: 'http://lattes.cnpq.br/0000000000000001',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2013',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1996 - 1997',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2007 - 2011',
      ),
    ],
  ),
  Teacher(
    id: 2,
    name: 'Fernanda Costa Ribeiro',
    lattes: 'http://lattes.cnpq.br/0000000000000002',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Direito (em andamento)',
        institution: 'UFPR',
        period: '2000 - 2002',
      ),
      TeacherFormation(
        degree: 'Mestrado Profissional em Engenharia de Produção',
        institution: 'UFPR',
        period: '1998 - 1999',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1993 - 1994',
      ),
      TeacherFormation(
        degree: 'Curso técnico/profissionalizante',
        institution: 'UFF',
        period: '2000 - 2002',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Atividade Física Adaptada',
        institution: 'UnB',
        period: '1995 - 1998',
        workload: '372h',
      ),
    ],
  ),
  Teacher(
    id: 3,
    name: 'Rodrigo Almeida Nogueira',
    lattes: 'http://lattes.cnpq.br/0000000000000003',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1985 - 1986',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2014',
      ),
    ],
  ),
  Teacher(
    id: 4,
    name: 'Patricia Souza Cavalcante',
    lattes: 'http://lattes.cnpq.br/0000000000000004',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2001 - 2004',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1988 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFC',
        period: '2011 - 2015',
      ),
    ],
  ),
  Teacher(
    id: 5,
    name: 'Camila Ferreira Nascimento',
    lattes: 'http://lattes.cnpq.br/0000000000000005',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1985 - 1986',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2016 - 2021',
      ),
    ],
  ),
  Teacher(
    id: 6,
    name: 'Diego Martins Carvalho',
    lattes: 'http://lattes.cnpq.br/0000000000000006',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Direito',
        institution: 'UFMG',
        period: '2019 - 2023',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'UFSCar',
        period: '2010 - 2013',
      ),
    ],
  ),
  Teacher(
    id: 7,
    name: 'Juliana Pereira Rocha',
    lattes: 'http://lattes.cnpq.br/0000000000000007',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2001 - 2004',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1995 - 1997',
      ),
    ],
  ),
  Teacher(
    id: 8,
    name: 'Thiago Barbosa Correia',
    lattes: 'http://lattes.cnpq.br/0000000000000008',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Educação Física',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2013',
      ),
      TeacherFormation(
        degree: 'Mestrado em Biologia',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1992 - 1996',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'UFC',
        period: '1990 - 1991',
      ),
    ],
  ),
  Teacher(
    id: 9,
    name: 'Larissa Gomes Teixeira',
    lattes: 'http://lattes.cnpq.br/0000000000000009',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'UFC',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFC',
        period: '2010 - 2013',
      ),
    ],
  ),
  Teacher(
    id: 10,
    name: 'Eduardo Santos Monteiro',
    lattes: 'http://lattes.cnpq.br/0000000000000010',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Biologia',
        institution: 'UFSC',
        period: '2016 - 2021',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'UFSC',
        period: '2021 - 2025',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '1992 - 1995',
      ),
    ],
  ),
  Teacher(
    id: 11,
    name: 'Beatriz Lima Cordeiro',
    lattes: 'http://lattes.cnpq.br/0000000000000011',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Matemática Aplicada',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1997 - 1998',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2021 - 2025',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2013',
      ),
    ],
  ),
  Teacher(
    id: 12,
    name: 'Gustavo Henrique Vasconcelos',
    lattes: 'http://lattes.cnpq.br/0000000000000012',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1994 - 1996',
      ),
    ],
  ),
  Teacher(
    id: 13,
    name: 'Renata Alves Fontoura',
    lattes: 'http://lattes.cnpq.br/0000000000000013',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1998 - 1999',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2013',
      ),
    ],
  ),
  Teacher(
    id: 14,
    name: 'Vinicius Cardoso Duarte',
    lattes: 'http://lattes.cnpq.br/0000000000000014',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2001 - 2005',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1998 - 1999',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2013',
      ),
    ],
  ),
  Teacher(
    id: 15,
    name: 'Amanda Ribeiro Siqueira',
    lattes: 'http://lattes.cnpq.br/0000000000000015',
    academicBackground: [
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFES',
        period: '2001 - 2005',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Escolar',
        institution: 'UnB',
        period: '1998 - 2002',
        workload: '720h',
      ),
    ],
  ),
  Teacher(
    id: 16,
    name: 'Felipe Augusto Moreira',
    lattes: 'http://lattes.cnpq.br/0000000000000016',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em História',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '1990 - 1992',
      ),
      TeacherFormation(
        degree: 'Mestrado em Farmácia',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1998 - 2000',
      ),
      TeacherFormation(
        degree: 'Graduação em Jornalismo',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2014',
      ),
    ],
  ),
  Teacher(
    id: 17,
    name: 'Isabela Martins Freitas',
    lattes: 'http://lattes.cnpq.br/0000000000000017',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado Profissional em Jornalismo',
        institution: 'UFSC',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Graduação em Jornalismo',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1991 - 1995',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Direito Educacional',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2006 - 2007',
        workload: '420h',
      ),
      TeacherSpecialization(
        name: 'Metodologia do Ensino',
        institution: 'UFV',
        period: '2006 - 2007',
        workload: '360h',
      ),
    ],
  ),
  Teacher(
    id: 18,
    name: 'Rafael Nogueira Peixoto',
    lattes: 'http://lattes.cnpq.br/0000000000000018',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Pedagogia',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1995 - 1998',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Faculdade Horizonte (FH)',
        period: '2003 - 2005',
      ),
      TeacherFormation(
        degree: 'Graduação em Jornalismo',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1995 - 1997',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão de Projetos',
        institution: 'UFC',
        period: '1994 - 1995',
        workload: '510h',
      ),
    ],
  ),
  Teacher(
    id: 19,
    name: 'Vanessa Castro Lopes',
    lattes: 'http://lattes.cnpq.br/0000000000000019',
    academicBackground: [
      TeacherFormation(
        degree: 'Graduação em Jornalismo',
        institution: 'Faculdade Horizonte (FH)',
        period: '2004 - 2005',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFC',
        period: '2001 - 2005',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Fundamentos de Análise de Dados',
        institution: 'UFMG',
        period: '1998 - 2000',
        workload: '450h',
      ),
    ],
  ),
  Teacher(
    id: 20,
    name: 'Bruno Cesar Andrade',
    lattes: 'http://lattes.cnpq.br/0000000000000020',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Sistemas de Informação',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1997 - 1998',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1988 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1995 - 1996',
      ),
    ],
    complementaryEducation: [
      TeacherComplementaryFormation(
        name: 'Libras',
        institution: 'UFAL',
        year: '2011 - 2015',
        workload: 'N/A',
      ),
    ],
  ),
  Teacher(
    id: 21,
    name: 'Priscila Farias Bezerra',
    lattes: 'http://lattes.cnpq.br/0000000000000021',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2006 - 2007',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2020 - 2023',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1993 - 1994',
      ),
    ],
  ),
  Teacher(
    id: 22,
    name: 'Leonardo Matos Guedes',
    lattes: 'http://lattes.cnpq.br/0000000000000022',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFC',
        period: '1985 - 1987',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFC',
        period: '2020 - 2025',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Horizonte (FH)',
        period: '2010 - 2014',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado',
        institution: 'UFC',
        period: '1991 - 1995',
      ),
    ],
  ),
  Teacher(
    id: 23,
    name: 'Simone Araujo Vieira',
    lattes: 'http://lattes.cnpq.br/0000000000000023',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFC',
        period: '2019 - 2023',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia de Materiais',
        institution: 'Faculdade Horizonte (FH)',
        period: '1987 - 1989',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFSCar',
        period: '1997 - 2000',
      ),
      TeacherFormation(
        degree: 'Graduação em Sistemas de Informação',
        institution: 'Faculdade Horizonte (FH)',
        period: '2010 - 2013',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Horizonte (FH)',
        period: '2010 - 2014',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Escolar',
        institution: 'UnB',
        period: '2019 - 2023',
        workload: '360h',
      ),
      TeacherSpecialization(
        name: 'Gestão de Projetos',
        institution: 'Faculdade Horizonte (FH)',
        period: '1998 - 2000',
        workload: '390h',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado',
        institution: 'UnB',
        period: '1998 - 2002',
      ),
    ],
  ),
  Teacher(
    id: 24,
    name: 'Daniel Rocha Meireles',
    lattes: 'http://lattes.cnpq.br/0000000000000024',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Sistemas de Informação',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1992 - 1995',
      ),
      TeacherFormation(
        degree: 'Mestrado em Farmácia',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2001 - 2004',
      ),
      TeacherFormation(
        degree: 'Graduação em Física',
        institution: 'UFC',
        period: '1995 - 1998',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'UFC',
        period: '1993 - 1994',
      ),
    ],
  ),
  Teacher(
    id: 25,
    name: 'Tatiane Correia Sales',
    lattes: 'http://lattes.cnpq.br/0000000000000025',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'Faculdade Horizonte (FH)',
        period: '1995 - 1998',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Horizonte (FH)',
        period: '2015 - 2017',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Ambiental',
        institution: 'Faculdade Horizonte (FH)',
        period: '1985 - 1989',
        workload: '390h',
      ),
    ],
  ),
  Teacher(
    id: 26,
    name: 'Marcelo Dantas Coelho',
    lattes: 'http://lattes.cnpq.br/0000000000000026',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Engenharia Civil',
        institution: 'UFC',
        period: '1993 - 1995',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'UFC',
        period: '2010 - 2013',
      ),
    ],
  ),
  Teacher(
    id: 27,
    name: 'Aline Sousa Barreto',
    lattes: 'http://lattes.cnpq.br/0000000000000027',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Ciências Sociais',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2001 - 2006',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2006 - 2007',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'UFC',
        period: '1988 - 1991',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2010 - 2015',
      ),
    ],
  ),
  Teacher(
    id: 28,
    name: 'Igor Pimentel Cavalcanti',
    lattes: 'http://lattes.cnpq.br/0000000000000028',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Química',
        institution: 'UFPR',
        period: '1994 - 1995',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFPR',
        period: '1991 - 1995',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'UFPR',
        period: '1988 - 1992',
      ),
    ],
  ),
  Teacher(
    id: 29,
    name: 'Cristina Melo Andrade',
    lattes: 'http://lattes.cnpq.br/0000000000000029',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado Profissional em Geografia',
        institution: 'Faculdade Horizonte (FH)',
        period: '1998 - 2000',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Faculdade Horizonte (FH)',
        period: '2001 - 2004',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Ambiental',
        institution: 'Faculdade Horizonte (FH)',
        period: '2020 - 2025',
        workload: '390h',
      ),
    ],
  ),
  Teacher(
    id: 30,
    name: 'Fabio Henrique Lacerda',
    lattes: 'http://lattes.cnpq.br/0000000000000030',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia de Produção',
        institution: 'UFC',
        period: '2001 - 2004',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'UFC',
        period: '1988 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFC',
        period: '1988 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'UFES',
        period: '1994 - 1995',
      ),
    ],
  ),
  Teacher(
    id: 31,
    name: 'Eduardo Santos Monteiro',
    lattes: 'http://lattes.cnpq.br/0000000000000010',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFSC',
        period: '2016 - 2021',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFES',
        period: '1995 - 1998',
      ),
      TeacherFormation(
        degree: 'Graduação em Biologia',
        institution: 'UFV',
        period: '1989 - 1993',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Ensino a Distância',
        institution: 'UFAL',
        period: '2022 - 2027',
        workload: '360h',
      ),
      TeacherSpecialization(
        name: 'Fundamentos de Análise de Dados',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '1992 - 1996',
        workload: '360h',
      ),
    ],
  ),
  Teacher(
    id: 32,
    name: 'Michele Torres Aguiar',
    lattes: 'http://lattes.cnpq.br/0000000000000032',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2004 - 2008',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia Mecânica',
        institution: 'UFC',
        period: '1996 - 1997',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFC',
        period: '2007 - 2011',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Direito Educacional',
        institution: 'UFAL',
        period: '1994 - 1996',
        workload: '680h',
      ),
      TeacherSpecialization(
        name: 'Gestão Escolar',
        institution: 'UFES',
        period: '2017 - 2022',
        workload: '380h',
      ),
    ],
  ),
  Teacher(
    id: 33,
    name: 'Alexandre Nunes Pontes',
    lattes: 'http://lattes.cnpq.br/0000000000000033',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado Profissional em Estatística',
        institution: 'Faculdade Horizonte (FH)',
        period: '1991 - 1995',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'UFES',
        period: '2014 - 2015',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Direito Educacional',
        institution: 'UFPR',
        period: '1998 - 1999',
        workload: '405h',
      ),
    ],
  ),
  Teacher(
    id: 34,
    name: 'Sabrina Diniz Marques',
    lattes: 'http://lattes.cnpq.br/0000000000000034',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'Faculdade Horizonte (FH)',
        period: '1985 - 1986',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2020 - 2023',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFG',
        period: '1986 - 1988',
      ),
      TeacherFormation(
        degree: 'Graduação em Jornalismo',
        institution: 'Faculdade Horizonte (FH)',
        period: '2010 - 2014',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Direito Educacional',
        institution: 'UnB',
        period: '1994 - 1996',
        workload: '710h',
      ),
    ],
  ),
  Teacher(
    id: 35,
    name: 'Leonardo Matos Guedes',
    lattes: 'http://lattes.cnpq.br/0000000000000022',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFC',
        period: '1985 - 1987',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFC',
        period: '2020 - 2025',
      ),
      TeacherFormation(
        degree:
            'Graduação em Licenciatura e Bacharelado em Ciências Biológicas',
        institution: 'Faculdade Horizonte (FH)',
        period: '2010 - 2014',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado',
        institution: 'UFC',
        period: '1991 - 1995',
      ),
    ],
  ),
  Teacher(
    id: 36,
    name: 'Wesley Batista Fagundes',
    lattes: 'http://lattes.cnpq.br/0000000000000036',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Letras',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '1998 - 1999',
      ),
      TeacherFormation(
        degree: 'Graduação em Física',
        institution: 'Centro Universitário Nova Era (CUNE)',
        period: '1995 - 1996',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'UFC',
        period: '1993 - 1995',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Atividade Física Adaptada',
        institution: 'UFES',
        period: '1985 - 1989',
        workload: '480h',
      ),
    ],
  ),
  Teacher(
    id: 37,
    name: 'Carla Regina Amaral',
    lattes: 'http://lattes.cnpq.br/0000000000000037',
    academicBackground: [
      TeacherFormation(
        degree:
            'Mestrado Profissional em Propriedade Intelectual e Transferência '
            'de Tecnologia para Inovação (PROFNIT)',
        institution: 'UFES',
        period: '1997 - 2001',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'Faculdade Horizonte (FH)',
        period: '2010 - 2014',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Metodologia do Ensino',
        institution: 'UFV',
        period: '2010 - 2013',
        workload: '360h',
      ),
    ],
  ),
  Teacher(
    id: 38,
    name: 'Ricardo Bastos Feitosa',
    lattes: 'http://lattes.cnpq.br/0000000000000038',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Matemática Aplicada',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2000 - 2002',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia Mecânica',
        institution: 'UFU',
        period: '2006 - 2007',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFMG',
        period: '2019 - 2023',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Fundamentos de Análise de Dados',
        institution: 'UFMG',
        period: '1986 - 1990',
        workload: '420h',
      ),
    ],
  ),
];
