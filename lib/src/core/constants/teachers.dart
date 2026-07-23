import 'package:academic_planner/src/features/teacher/domain/entities/teacher.dart';

const teachers = <Teacher>[
  Teacher(
    id: 1,
    name: 'Marcos Vinicius Andrade Lima',
    lattes: 'http://lattes.cnpq.br/0000000000000001',
    academicBackground: [
      TeacherFormation(
        degree: 'Doutorado em Engenharia Civil',
        institution: 'Faculdade Pioneira (FP)',
        period: '1998 - 2003',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Faculdade Pioneira (FP)',
        period: '1988 - 1991',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'Faculdade Pioneira (FP)',
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
        institution: 'Faculdade Boa Vista (FBV)',
        period: '1994 - 1996',
      ),
      TeacherFormation(
        degree: 'Mestrado Profissional em Administração',
        institution: 'Centro Educacional Serra Alta (CESA)',
        period: '1996 - 2001',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'Instituto Superior do Vale (ISV)',
        period: '1990 - 1994',
      ),
      TeacherFormation(
        degree: 'Curso técnico/profissionalizante em Engenharia Mecânica',
        institution: 'Centro Educacional Serra Alta (CESA)',
        period: '2005 - 2009',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Formação em Tutoria Acadêmica',
        institution: 'Universidade Regional do Litoral (URL)',
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
        institution: 'Faculdade Pioneira (FP)',
        period: '2020 - 2025',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia Civil',
        institution: 'Centro Universitário Vale do Sol (CUVS)',
        period: '2015 - 2017',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
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
        institution: 'Faculdade Nova Aliança (FNA)',
        period: '1990 - 1995',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Centro Universitário Aurora (CUA)',
        period: '2006 - 2011',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
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
        institution: 'Faculdade Pioneira (FP)',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'Centro Educacional Serra Alta (CESA)',
        period: '2021 - 2023',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Vale Verde (IVV)',
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
        institution: 'Faculdade Nova Aliança (FNA)',
        period: '2003 - 2005',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Centro Universitário Aurora (CUA)',
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
        institution: 'Centro Universitário Aurora (CUA)',
        period: '1995 - 1998',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Boa Vista (FBV)',
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
        institution: 'Universidade Metropolitana do Sul (UMS)',
        period: '2020 - 2022',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Vale Verde (IVV)',
        period: '2000 - 2002',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Faculdade Pioneira (FP)',
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
        institution: 'Faculdade Estrela do Norte (FEN)',
        period: '2001 - 2005',
      ),
      TeacherFormation(
        degree: 'Graduação em Estatística',
        institution: 'Faculdade Pioneira (FP)',
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
        institution: 'Faculdade Boa Vista (FBV)',
        period: '1996 - 1997',
      ),
      TeacherFormation(
        degree: 'Mestrado em Educação',
        institution: 'Universidade Metropolitana do Sul (UMS)',
        period: '1997 - 2002',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Centro Universitário Vale do Sol (CUVS)',
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
        institution: 'Instituto Superior do Vale (ISV)',
        period: '1992 - 1994',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia Mecânica',
        institution: 'Instituto Vale Verde (IVV)',
        period: '1995 - 1997',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Nova Aliança (FNA)',
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
        institution: 'Faculdade Pioneira (FP)',
        period: '2003 - 2005',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'Instituto Politécnico Aurora (IPA)',
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
        institution: 'Centro Universitário Novo Horizonte (CUNH)',
        period: '2001 - 2004',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Nova Aliança (FNA)',
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
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Mestrado em Engenharia Civil',
        institution: 'Faculdade Estrela do Norte (FEN)',
        period: '2010 - 2015',
      ),
      TeacherFormation(
        degree: 'Graduação em Sistemas de Informação',
        institution: 'Universidade Metropolitana do Sul (UMS)',
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
        institution: 'Centro Universitário Vale do Sol (CUVS)',
        period: '2019 - 2023',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Ferramentas Digitais para Educação',
        institution: 'Instituto Vale Verde (IVV)',
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
        institution: 'Faculdade Nova Aliança (FNA)',
        period: '2010 - 2013',
      ),
      TeacherFormation(
        degree: 'Mestrado em Biologia',
        institution: 'Universidade Regional do Litoral (URL)',
        period: '2001 - 2004',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
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
        institution: 'Universidade Regional do Litoral (URL)',
        period: '2005 - 2009',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Centro Universitário Vale do Sol (CUVS)',
        period: '2020 - 2023',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Comunicação Institucional',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
        period: '2019 - 2023',
        workload: '420h',
      ),
      TeacherSpecialization(
        name: 'Fundamentos de Análise de Dados',
        institution: 'Faculdade Nova Aliança (FNA)',
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
        institution: 'Instituto Vale Verde (IVV)',
        period: '1990 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Instituto Vale Verde (IVV)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Faculdade Boa Vista (FBV)',
        period: '1996 - 1998',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Acessibilidade e Inclusão',
        institution: 'Faculdade Boa Vista (FBV)',
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
        institution: 'Centro Universitário Aurora (CUA)',
        period: '1996 - 2000',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Superior do Vale (ISV)',
        period: '2021 - 2025',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Acessibilidade e Inclusão',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
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
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
        period: '2003 - 2005',
      ),
      TeacherFormation(
        degree: 'Mestrado em Letras',
        institution: 'Centro Universitário Novo Horizonte (CUNH)',
        period: '1988 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Faculdade Nova Aliança (FNA)',
        period: '2001 - 2004',
      ),
    ],
    complementaryEducation: [
      TeacherComplementaryFormation(
        name: 'Planejamento Educacional',
        institution: 'Faculdade Boa Vista (FBV)',
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
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2021 - 2023',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Faculdade Estrela do Norte (FEN)',
        period: '1993 - 1995',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'Faculdade Nova Aliança (FNA)',
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
        institution: 'Centro Universitário Vale do Sol (CUVS)',
        period: '2007 - 2011',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Faculdade Estrela do Norte (FEN)',
        period: '1990 - 1994',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Vale Verde (IVV)',
        period: '1998 - 2000',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado em Letras',
        institution: 'Centro Universitário Novo Horizonte (CUNH)',
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
        institution: 'Universidade Regional do Litoral (URL)',
        period: '2019 - 2023',
      ),
      TeacherFormation(
        degree: 'Mestrado em Administração',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Universidade Metropolitana do Sul (UMS)',
        period: '1990 - 1992',
      ),
      TeacherFormation(
        degree: 'Graduação em Sistemas de Informação',
        institution: 'Universidade Regional do Litoral (URL)',
        period: '1992 - 1995',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'Instituto Vale Verde (IVV)',
        period: '2021 - 2025',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Comunicação Institucional',
        institution: 'Centro Universitário Aurora (CUA)',
        period: '1992 - 1994',
        workload: '360h',
      ),
      TeacherSpecialization(
        name: 'Planejamento Educacional',
        institution: 'Faculdade Pioneira (FP)',
        period: '2001 - 2004',
        workload: '390h',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado em Estatística',
        institution: 'Instituto Superior do Vale (ISV)',
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
        institution: 'Centro Educacional Serra Alta (CESA)',
        period: '1998 - 2003',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'Faculdade Boa Vista (FBV)',
        period: '1997 - 1998',
      ),
      TeacherFormation(
        degree: 'Graduação em Biologia',
        institution: 'Faculdade Pioneira (FP)',
        period: '1992 - 1994',
      ),
      TeacherFormation(
        degree: 'Graduação em Biologia',
        institution: 'Faculdade Boa Vista (FBV)',
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
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1996 - 1997',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'Centro Universitário Novo Horizonte (CUNH)',
        period: '1996 - 1998',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Mediação de Conflitos',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
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
        institution: 'Universidade Regional do Litoral (URL)',
        period: '2021 - 2025',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
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
        institution: 'Centro Universitário Novo Horizonte (CUNH)',
        period: '2001 - 2005',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Faculdade Boa Vista (FBV)',
        period: '1991 - 1996',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Instituto Vale Verde (IVV)',
        period: '1988 - 1992',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado em Física',
        institution: 'Instituto Politécnico Aurora (IPA)',
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
        institution: 'Centro Universitário Vale do Sol (CUVS)',
        period: '2005 - 2009',
      ),
      TeacherFormation(
        degree: 'Mestrado em Sistemas de Informação',
        institution: 'Instituto Vale Verde (IVV)',
        period: '2000 - 2002',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'Faculdade Boa Vista (FBV)',
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
        institution: 'Centro Educacional Serra Alta (CESA)',
        period: '1992 - 1997',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
        period: '2020 - 2024',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Introdução à Sustentabilidade',
        institution: 'Universidade Regional do Litoral (URL)',
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
        institution: 'Centro Universitário Aurora (CUA)',
        period: '2019 - 2023',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Produção',
        institution: 'Faculdade Boa Vista (FBV)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Engenharia de Materiais',
        institution: 'Faculdade Pioneira (FP)',
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
        institution: 'Instituto Politécnico Aurora (IPA)',
        period: '2000 - 2002',
      ),
      TeacherFormation(
        degree: 'Mestrado em Sistemas de Informação',
        institution: 'Instituto Vale Verde (IVV)',
        period: '2011 - 2016',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'Faculdade Estrela do Norte (FEN)',
        period: '1994 - 1996',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Comunicação Institucional',
        institution: 'Centro Universitário Vale do Sol (CUVS)',
        period: '2007 - 2011',
        workload: '360h',
      ),
      TeacherSpecialization(
        name: 'Ferramentas Digitais para Educação',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
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
        institution: 'Faculdade Nova Aliança (FNA)',
        period: '1988 - 1992',
      ),
      TeacherFormation(
        degree: 'Mestrado em Química',
        institution: 'Faculdade Nova Aliança (FNA)',
        period: '1997 - 2001',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Nova Aliança (FNA)',
        period: '1992 - 1996',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Metodologias Ativas de Ensino',
        institution: 'Faculdade Boa Vista (FBV)',
        period: '2001 - 2004',
        workload: '680h',
      ),
      TeacherSpecialization(
        name: 'Acessibilidade e Inclusão',
        institution: 'Universidade Metropolitana do Sul (UMS)',
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
        institution: 'Instituto Vale Verde (IVV)',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'Instituto Técnico Rio Claro (ITRC)',
        period: '1995 - 1998',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Gestão de Equipes e Processos',
        institution: 'Instituto Técnico Rio Claro (ITRC)',
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
        institution: 'Faculdade Pioneira (FP)',
        period: '2016 - 2021',
      ),
      TeacherFormation(
        degree: 'Mestrado em Sistemas de Informação',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1992 - 1994',
      ),
      TeacherFormation(
        degree: 'Graduação em Estatística',
        institution: 'Instituto Superior do Vale (ISV)',
        period: '1986 - 1990',
      ),
      TeacherFormation(
        degree: 'Graduação em Matemática Aplicada',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '2010 - 2013',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Metodologias Ativas de Ensino',
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
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
        institution: 'Centro Educacional Serra Alta (CESA)',
        period: '1985 - 1986',
      ),
      TeacherFormation(
        degree: 'Mestrado em Matemática Aplicada',
        institution: 'Instituto Superior Horizonte (ISH)',
        period: '1995 - 1998',
      ),
      TeacherFormation(
        degree:
            'Graduação em Licenciatura e Bacharelado em Ciências Biológicas',
        institution: 'Centro Universitário Vale do Sol (CUVS)',
        period: '2011 - 2015',
      ),
    ],
    postDoctorate: [
      TeacherFormation(
        degree: 'Pós-Doutorado em Administração',
        institution: 'Universidade Metropolitana do Sul (UMS)',
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
        institution: 'Universidade Metropolitana do Sul (UMS)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Faculdade Boa Vista (FBV)',
        period: '2006 - 2007',
      ),
      TeacherFormation(
        degree: 'Graduação em Educação',
        institution: 'Centro Educacional Serra Alta (CESA)',
        period: '2015 - 2017',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Fundamentos de Análise de Dados',
        institution: 'Faculdade Boa Vista (FBV)',
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
        institution: 'Universidade Comunitária Bela Vista (UCBV)',
        period: '1998 - 2000',
      ),
      TeacherFormation(
        degree: 'Graduação em Ciências Sociais',
        institution: 'Instituto Superior do Vale (ISV)',
        period: '2006 - 2007',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Introdução à Sustentabilidade',
        institution: 'Faculdade Nova Aliança (FNA)',
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
        institution: 'Centro Universitário Novo Horizonte (CUNH)',
        period: '1992 - 1996',
      ),
      TeacherFormation(
        degree: 'Mestrado em Ciências Sociais',
        institution: 'Centro Universitário Aurora (CUA)',
        period: '2010 - 2014',
      ),
      TeacherFormation(
        degree: 'Graduação em Sistemas de Informação',
        institution: 'Universidade Regional do Litoral (URL)',
        period: '1990 - 1995',
      ),
    ],
    postGraduation: [
      TeacherSpecialization(
        name: 'Ferramentas Digitais para Educação',
        institution: 'Universidade Regional do Litoral (URL)',
        period: '2020 - 2023',
        workload: '420h',
      ),
    ],
  ),
];
