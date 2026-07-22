import 'package:academic_planner/src/features/teacher/domain/entities/teacher.dart';

const teachers = <Teacher>[
  Teacher(
    id: 1,
    name: 'Marcos Vinicius Andrade Lima',
    lattes: 'http://lattes.cnpq.br/0000000000000001',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFF',
        period: '1998 - 2003',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UnB',
        period: '1988 - 1991',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'UFC',
        period: '1990 - 1992',
      ),
    ],
  ),
  Teacher(
    id: 2,
    name: 'Fernanda Costa Ribeiro',
    lattes: 'http://lattes.cnpq.br/0000000000000002',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Administração (em andamento)',
        institution: 'UFSCar',
        period: '1994 - 1996',
      ),
      TeacherFormation(
        degree: 'Mestrado Profissional em Administração',
        institution: 'UFPR',
        period: '1996 - 2001',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'UFAL',
        period: '1990 - 1994',
      ),
      TeacherFormation(
        degree: 'Curso técnico/profissionalizante em Engenharia Mecânica',
        institution: 'UFPR',
        period: '2005 - 2009',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Direito Educacional',
        institution: 'Faculdade Horizonte (FH)',
        period: '2006 - 2007',
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
        degree: 'Doutorado em Educação Física',
        institution: 'UFC',
        period: '2020 - 2025',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia Civil',
        institution: 'UnB',
        period: '2015 - 2017',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'UnB',
        period: '2000 - 2004',
      ),
    ],
  ),
  Teacher(
    id: 4,
    name: 'Patricia Souza Cavalcante',
    lattes: 'http://lattes.cnpq.br/0000000000000004',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia de Produção',
        institution: 'UFG',
        period: '1990 - 1995',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFAL',
        period: '2006 - 2011',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFRJ',
        period: '2019 - 2023',
      ),
    ],
  ),
  Teacher(
    id: 5,
    name: 'Camila Ferreira Nascimento',
    lattes: 'http://lattes.cnpq.br/0000000000000005',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFRJ',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'UFG',
        period: '2021 - 2023',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFSC',
        period: '2000 - 2002',
      ),
    ],
  ),
  Teacher(
    id: 6,
    name: 'Diego Martins Carvalho',
    lattes: 'http://lattes.cnpq.br/0000000000000006',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Pedagogia',
        institution: 'UFSCar',
        period: '2003 - 2005',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'UNIFESP',
        period: '1993 - 1997',
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
        institution: 'UFU',
        period: '1995 - 1998',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '1993 - 1997',
      ),
    ],
  ),
  Teacher(
    id: 8,
    name: 'Thiago Barbosa Correia',
    lattes: 'http://lattes.cnpq.br/0000000000000008',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Química',
        institution: 'Faculdade Horizonte (FH)',
        period: '2020 - 2022',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFU',
        period: '2000 - 2002',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UNIFESP',
        period: '1995 - 1999',
      ),
    ],
  ),
  Teacher(
    id: 9,
    name: 'Larissa Gomes Teixeira',
    lattes: 'http://lattes.cnpq.br/0000000000000009',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Administração',
        institution: 'UFES',
        period: '2001 - 2005',
      ),
      TeacherFormation(
        degree: 'Graduação em Estatística',
        institution: 'Faculdade Horizonte (FH)',
        period: '1992 - 1995',
      ),
    ],
  ),
  Teacher(
    id: 10,
    name: 'Eduardo Santos Monteiro',
    lattes: 'http://lattes.cnpq.br/0000000000000010',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Ciências Sociais',
        institution: 'UFMG',
        period: '1996 - 1997',
      ),
      TeacherFormation(
        degree: 'Mestrado em Educação',
        institution: 'UnB',
        period: '1997 - 2002',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UnB',
        period: '1996 - 1997',
      ),
    ],
  ),
  Teacher(
    id: 11,
    name: 'Beatriz Lima Cordeiro',
    lattes: 'http://lattes.cnpq.br/0000000000000011',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFSC',
        period: '1992 - 1994',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia Mecânica',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '1995 - 1997',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'UNIFESP',
        period: '2010 - 2015',
      ),
    ],
  ),
  Teacher(
    id: 12,
    name: 'Gustavo Henrique Vasconcelos',
    lattes: 'http://lattes.cnpq.br/0000000000000012',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Educação',
        institution: 'UFSCar',
        period: '2003 - 2005',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'UnB',
        period: '1995 - 1998',
      ),
    ],
  ),
  Teacher(
    id: 13,
    name: 'Renata Alves Fontoura',
    lattes: 'http://lattes.cnpq.br/0000000000000013',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'UFSCar',
        period: '2001 - 2004',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Horizonte (FH)',
        period: '1998 - 2003',
      ),
    ],
  ),
  Teacher(
    id: 14,
    name: 'Vinicius Cardoso Duarte',
    lattes: 'http://lattes.cnpq.br/0000000000000014',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFMG',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia Civil',
        institution: 'UFSCar',
        period: '2010 - 2015',
      ),
      TeacherFormation(
        degree: 'Graduação em Sistemas de Informação',
        institution: 'UFG',
        period: '1992 - 1995',
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
        institution: 'UFMA',
        period: '2019 - 2023',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Libras',
        institution: 'UFC',
        period: '1996 - 1998',
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
        degree: 'Doutorado em Biologia',
        institution: 'UFF',
        period: '2010 - 2013',
      ),
      TeacherFormation(
        degree: 'Mestrado em Biologia',
        institution: 'UnB',
        period: '2001 - 2004',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'UFU',
        period: '1991 - 1995',
      ),
    ],
  ),
  Teacher(
    id: 17,
    name: 'Isabela Martins Freitas',
    lattes: 'http://lattes.cnpq.br/0000000000000017',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado Profissional em Educação',
        institution: 'UFSCar',
        period: '2005 - 2009',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2020 - 2023',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Libras',
        institution: 'UFG',
        period: '2019 - 2023',
        workload: '420h',
      ),
      TeacherSpecialization(
        name: 'Ciência de Dados',
        institution: 'UFES',
        period: '1997 - 1998',
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
        degree: 'Mestrado em Estatística',
        institution: 'UFPR',
        period: '1990 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Faculdade Horizonte (FH)',
        period: '1996 - 1998',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Fundamentos de Análise de Dados',
        institution: 'UFF',
        period: '2001 - 2004',
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
        degree: 'Graduação em Sistemas de Informação',
        institution: 'UFMG',
        period: '1996 - 2000',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UnB',
        period: '2021 - 2025',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Escolar',
        institution: 'UFPR',
        period: '2020 - 2023',
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
        degree: 'Doutorado em Educação Física',
        institution: 'UnB',
        period: '2003 - 2005',
      ),
      TeacherFormation(
        degree: 'Mestrado em Letras',
        institution: 'UFV',
        period: '1988 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'UFAL',
        period: '2001 - 2004',
      ),
    ],
    complementaryEducation: [
      TeacherComplementaryFormation(
        name: 'Gestão Escolar',
        institution: 'UFAL',
        year: '2003 - 2005',
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
        degree: 'Doutorado em Biologia',
        institution: 'UFPR',
        period: '2021 - 2023',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFAL',
        period: '1993 - 1995',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'UFU',
        period: '2019 - 2023',
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
        period: '2007 - 2011',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFC',
        period: '1990 - 1994',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFPR',
        period: '1998 - 2000',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado em Letras',
        institution: 'UFU',
        period: '2001 - 2004',
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
        institution: 'UnB',
        period: '2019 - 2023',
      ),
      TeacherFormation(
        degree: 'Mestrado em Administração',
        institution: 'UNIFESP',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFSCar',
        period: '1990 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Sistemas de Informação',
        institution: 'UFG',
        period: '1992 - 1995',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'UnB',
        period: '2021 - 2025',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Escolar',
        institution: 'UFMA',
        period: '1992 - 1994',
        workload: '360h',
      ),
      TeacherSpecialization(
        name: 'Ciência de Dados',
        institution: 'UFU',
        period: '2001 - 2004',
        workload: '390h',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado em Estatística',
        institution: 'UFMA',
        period: '2021 - 2025',
      ),
    ],
  ),
  Teacher(
    id: 24,
    name: 'Daniel Rocha Meireles',
    lattes: 'http://lattes.cnpq.br/0000000000000024',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Biologia',
        institution: 'UFMG',
        period: '1998 - 2003',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'UFRJ',
        period: '1997 - 1998',
      ),
      TeacherFormation(
        degree: 'Graduação em Biologia',
        institution: 'UFF',
        period: '1992 - 1994',
      ),
      TeacherFormation(
        degree: 'Graduação em Biologia',
        institution: 'UFSC',
        period: '2003 - 2005',
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
        institution: 'UFSCar',
        period: '1996 - 1997',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'UFSC',
        period: '1996 - 1998',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Metodologia do Ensino',
        institution: 'Faculdade Horizonte (FH)',
        period: '2006 - 2007',
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
        institution: 'UnB',
        period: '2021 - 2025',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'UnB',
        period: '2000 - 2002',
      ),
    ],
  ),
  Teacher(
    id: 27,
    name: 'Aline Sousa Barreto',
    lattes: 'http://lattes.cnpq.br/0000000000000027',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFAL',
        period: '2001 - 2005',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFES',
        period: '1991 - 1996',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '1988 - 1992',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado em Física',
        institution: 'UFV',
        period: '2001 - 2005',
      ),
    ],
  ),
  Teacher(
    id: 28,
    name: 'Igor Pimentel Cavalcanti',
    lattes: 'http://lattes.cnpq.br/0000000000000028',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Estatística',
        institution: 'UFU',
        period: '2005 - 2009',
      ),
      TeacherFormation(
        degree: 'Mestrado em Sistemas de Informação',
        institution: 'UnB',
        period: '2000 - 2002',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'UFV',
        period: '1996 - 2000',
      ),
    ],
  ),
  Teacher(
    id: 29,
    name: 'Cristina Melo Andrade',
    lattes: 'http://lattes.cnpq.br/0000000000000029',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado Profissional em Educação Física',
        institution: 'UnB',
        period: '1992 - 1997',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2020 - 2024',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Ensino a Distância',
        institution: 'UFAL',
        period: '2000 - 2002',
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
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFPR',
        period: '2019 - 2023',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UnB',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'UFAL',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'UFPR',
        period: '1991 - 1993',
      ),
    ],
  ),
  Teacher(
    id: 31,
    name: 'Eduardo Santos Monteiro',
    lattes: 'http://lattes.cnpq.br/0000000000000031',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'UFES',
        period: '2000 - 2002',
      ),
      TeacherFormation(
        degree: 'Mestrado em Sistemas de Informação',
        institution: 'UFAL',
        period: '2011 - 2016',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'UFSCar',
        period: '1994 - 1996',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Escolar',
        institution: 'UnB',
        period: '2007 - 2011',
        workload: '360h',
      ),
      TeacherSpecialization(
        name: 'Direito Educacional',
        institution: 'UNIFESP',
        period: '2015 - 2017',
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
        institution: 'UFPR',
        period: '1988 - 1992',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'UFMA',
        period: '1997 - 2001',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'UFU',
        period: '1992 - 1996',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Pública',
        institution: 'UFC',
        period: '2001 - 2004',
        workload: '680h',
      ),
      TeacherSpecialization(
        name: 'Ciência de Dados',
        institution: 'UFV',
        period: '1996 - 2000',
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
        degree: 'Mestrado Profissional em Geografia',
        institution: 'UFV',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'UFPR',
        period: '1995 - 1998',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Docência do Ensino Superior',
        institution: 'UnB',
        period: '1997 - 2002',
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
        degree: 'Doutorado em Pedagogia',
        institution: 'UFPR',
        period: '2016 - 2021',
      ),
      TeacherFormation(
        degree: 'Mestrado em Sistemas de Informação',
        institution: 'UnB',
        period: '1992 - 1994',
      ),
      TeacherFormation(
        degree: 'Graduação em Estatística',
        institution: 'UFMA',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'Faculdade Horizonte (FH)',
        period: '2010 - 2013',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão Ambiental',
        institution: 'Faculdade Horizonte (FH)',
        period: '1986 - 1990',
        workload: '710h',
      ),
    ],
  ),
  Teacher(
    id: 35,
    name: 'Leonardo Matos Guedes',
    lattes: 'http://lattes.cnpq.br/0000000000000035',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Educação',
        institution: 'UnB',
        period: '1985 - 1986',
      ),
      TeacherFormation(
        degree: 'Mestrado em Matemática Aplicada',
        institution: 'UFF',
        period: '1995 - 1998',
      ),
      TeacherFormation(
        degree:
            'Graduação em Licenciatura e Bacharelado em Ciências Biológicas',
        institution: 'UnB',
        period: '2011 - 2015',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado em Administração',
        institution: 'UnB',
        period: '2010 - 2014',
      ),
    ],
  ),
  Teacher(
    id: 36,
    name: 'Wesley Batista Fagundes',
    lattes: 'http://lattes.cnpq.br/0000000000000036',
    academicBackground: [
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFSC',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'UFPR',
        period: '2006 - 2007',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'Faculdade Horizonte (FH)',
        period: '2015 - 2017',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Ensino a Distância',
        institution: 'UFPR',
        period: '2020 - 2023',
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
        institution: 'UFRJ',
        period: '1998 - 2000',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'UFES',
        period: '2006 - 2007',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Ciência de Dados',
        institution: 'Faculdade Horizonte (FH)',
        period: '1987 - 1989',
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
        degree: 'Doutorado em Engenharia de Produção',
        institution: 'UnB',
        period: '1992 - 1996',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'UFMA',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Sistemas de Informação',
        institution: 'UFMA',
        period: '1990 - 1995',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Ciência de Dados',
        institution: 'UFU',
        period: '2020 - 2023',
        workload: '420h',
      ),
    ],
  ),
];
