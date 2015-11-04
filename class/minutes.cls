% Copyright (C) 2015 Vereniging Informatiewetenschappen Amsterdam

\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{minutes}[2011/01/25 v1.0 via-minutes]

\newif\ifeng@art \eng@artfalse

\DeclareOption{english}{\eng@arttrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions

\LoadClass[a4paper,11pt]{article}

\ifeng@art\RequirePackage[english]{babel}
\else\RequirePackage[dutch]{babel}
\fi

\RequirePackage{eurosym, minitoc, fancyhdr, helvet, lineno, ifthen}
\RequirePackage[utf8]{inputenc}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\if@twoside
    \setlength{\oddsidemargin}	{35mm}
    \setlength{\evensidemargin}	{25mm}
\else
    \setlength{\oddsidemargin}	{30mm}
    \setlength{\evensidemargin}	{30mm}
\fi

\setlength{\hoffset}		{-1in}
\setlength{\voffset}		{-1in}

\setlength{\textwidth}		{150mm}
\setlength{\textheight}		{230mm}
\setlength{\topmargin}		{20mm}
\setlength{\headheight}		{1.5em}
\setlength{\headsep}		{2em}
\setlength{\footskip}		{4em}

\setlength{\parindent}		{0em}
\setlength{\parskip}		{0em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\pagestyle{fancy}

\lhead{\min@title}
\chead{}
\rhead{\min@date}
\lfoot{}
\cfoot{\thepage}
\rfoot{}

\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.0pt}

\modulolinenumbers[5]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand\familydefault{\sfdefault}

\setcounter{secnumdepth}{1}
\setcounter{tocdepth}{2}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \renewcommand{\section}{
%   \@startsection{section}{1}{\z@}
%     {-2.5ex \@plus -1ex \@minus -.2ex}
%     {1.3ex \@plus.2ex}
%     {\normalfont\Large\bfseries}}
% \renewcommand{\subsection}{
%   \@startsection{subsection}{2}{\z@}
%     {-1.25ex\@plus -1ex \@minus -.2ex}
%     {0.5ex \@plus .2ex}
%     {\normalfont\large\itshape}}
% \renewcommand{\subsubsection}{
%   \@startsection{subsubsection}{3}{\z@}
%     {-1.00ex \@plus -0.50ex \@minus -0.50ex}
%     {-1.00ex \@plus -0.50ex \@minus -0.50ex}
%     {\normalfont\normalsize\itshape\bfseries}}
% \renewcommand{\paragraph}{
%   \@startsection{paragraph}{4}{\z@}
%     {0.00ex \@plus0.1ex}
%     {-1em}
%     {\normalfont\normalsize\nameshape}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\decisionlistname}{Besluitenlijst}
\newcommand{\decisionlistentry}{
    \addcontentsline{toc}{section}{\decisionlistname}
}

\newcommand{\decisionlist}{%
    \decisionlistentry
    \section*{\decisionlistname
      \@mkboth{\MakeUppercase\decisionlistname}%
              {\MakeUppercase\decisionlistname}}%
    \@starttoc{lod}%
}

\newcommand{\l@decision}{\@dottedtocline{1}{1.5em}{2.3em}}

\newcommand{\decision}[1]{\par
    \textbf{Besluit:} \hspace{5mm} #1
    \addcontentsline{lod}{decision}
    {\not@thedecision\hspace{1em}{#1}}
    \addtocounter{decision}{1}
}

\newcommand{\silentdecision}[1]{%
    \addcontentsline{lod}{decision}
    {\not@thedecision\hspace{1em}{#1}}
}

\newcounter{decision}
\setcounter{decision}{1}
\newcommand{\not@thedecision}{\@alph\c@decision}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tasks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\newcommand{\tasklistname}{Actiepunten}
\newcommand{\tasklistentry}{
  \addcontentsline{toc}{section}{\tasklistname}
}

% Hulpcommando. Maakt een tasklist nadat je een \@task-
% commando hebt gedefinieerd.
\newcommand{\task@buildtasklist}{%
    \tasklistentry
    \section*{\tasklistname
        \@mkboth{\MakeUppercase\tasklistname}%
    {\MakeUppercase\tasklistname}}%
    \@starttoc{loa}%
}


\def\verwijdern@@m#1#2{%
    \def\cleanup##1, !{%
        ##1%
    }
    \def\verwijder##1#2, ##2\relax{%
        \global\edef\tempn@menlijst{##1##2}%
    }
    \verwijder#1, \relax%
    \expandafter\cleanup\tempn@menlijst!%
}

% Defines a \@task for use with the \tasklistpp.
% \tasklist redefines this command for what it needs
\def\@task#1#2#3{% <- Name, Task, Page
  %
  % Zoek ##1 op in alle al bekende namen:
  \def\splitn@@m##1, {%
  \setcounter{task@curname}{0}%
  \setboolean{task@gebakt}{false}%
    \ifx\relax##1%
      \let\next@@\relax
    \else
      \let\next@@\splitn@@m
      \whiledo{\thetask@curname < \thetask@names}{%
        \ifthenelse{\equal{##1}{\csname task@name\thetask@curname\endcsname}}{%
          % Gevonden.
          % Laad het aantal eerdere taken van deze persoon in een counter:
          \setcounter{task@tmp}{\csname task@name\thetask@curname taken\endcsname}%
          % Definieer \task@nameXXtaakXX als de nieuwe taak:
          \global\expandafter\def\csname task@name\thetask@curname taak\thetask@tmp\endcsname{%
						\ifthenelse{\equal{#1}{##1}}{%
							\l@task{#2}{#3}
						}{%
							\l@task{+ \verwijdern@@m{#1}{##1}: #2}{#3}
						}
          }%
          % Hoog het aantal eerdere taken op:
          \stepcounter{task@tmp}%
          \global\expandafter\edef\csname task@name\thetask@curname taken\endcsname{\thetask@tmp}%

          % Onthoud dat deze name al bestond:
          \setboolean{task@gebakt}{true}%
        }{%
          % niks
        }%
        \stepcounter{task@curname}%
      }%
      % Als de name niet gevonden is, moeten we hem als nieuwe name definieren:
      \ifthenelse{\boolean{task@gebakt}}{%
      }{%
        % Initialiseer name, aantal taken (1) en de eerste taak:
        \global\expandafter\def\csname task@name\thetask@names\endcsname{##1}%
        \global\expandafter\edef\csname task@name\thetask@names taken\endcsname{1}%
        \global\expandafter\def\csname task@name\thetask@names taak0\endcsname{%
					\ifthenelse{\equal{#1}{##1}}{%
						\l@task{#2}{#3}
					}{%
						\l@task{+ \verwijdern@@m{#1}{##1}: #2}{#3}
					}
				}%
        % Het totaal aantal namen++
        \stepcounter{task@names}%
      }%
    \fi
    \next@@}%
  % splits #1 op komma's
  \expandafter\splitn@@m#1, \relax,%
}%

\newcommand*{\l@task}{\@dottedtocline{1}{1.5em}{2.3em}}

% Gebruikerscommando voor een actiepunt.
\newcommand{\task}[2]{\par
  \@intasklisttrue
  \textbf{Actie:} \hspace{0.5mm} \name{#1} #2
  \addtocontents{loa}{\protect\@task{#1}{#2}{\thepage}}
  \@intasklistfalse
}

\newif\if@intasklist
\newcommand{\shorttaskname}[2]{%
  \ifcsname#1\endcsname%
    \PackageError{minutes}{Het commando #1 bestaat al!}{Het commando #1 bestaat al!}%
  \fi%
  \expandafter\newcommand\csname #1\endcsname{%
    \if@intasklist%
      #2%
    \else%
      \mbox{\name{#2}}\xspace%
    \fi%
  }%
}


% Actiepuntenlijst; platte lijst.
\newcommand{\tasklist}{%
    \global\def\@task##1##2{\contentsline{task}{\name{##1} ##2}}%
    \task@buildtasklist%
}

% Hulpstukken voor \tasklistpp.
\newcounter{task@names}
\newcounter{task@curname}
\newcounter{task@tmp}
\newboolean{task@gebakt}

% Actiepuntenlijst; gegroepeerd per persoon.
% Tasklist; grouped by person
\newcommand{\tasklistpp}{%
    \tasklistentry
    \section*{\tasklistname
        \@mkboth{\MakeUppercase\tasklistname}%
        {\MakeUppercase\tasklistname}
    }%

    % All tasks will be handled in the order in which they were found.
    \setcounter{task@names}{0}%
    \setcounter{task@curname}{0}%

    % Load the loa-file and parse with \@task
    \@starttoc{loa}%

    % Loop through all the names
    \whiledo{\thetask@curname < \thetask@names}{%

        % Print the name of the current person
        \name{\csname task@name\thetask@curname\endcsname}
        \setcounter{task@tmp}{0}

        % Loop through all the tasks of the current name
        \whiledo{\thetask@tmp < \csname task@name\thetask@curname taken\endcsname}{%

            % Print saved tasks:
            \csname task@name\thetask@curname taak\thetask@tmp\endcsname
            \stepcounter{task@tmp}
        }%
        \stepcounter{task@curname}%
    }%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\min@title}   {Notulen \message{Waarschuwing: geen title ingevoerd}}
\newcommand{\min@date}   {\today  \message{Waarschuwing: geen date ingevoerd}}
\newcommand{\min@present}{Allen}
\newcommand{\min@absent}{}


\newcommand{\min@participants}{
    \ifthenelse{\equal{\min@absent}{}}%
    {\parbox[c]{\textwidth}{\centering aanwezig: \min@present}}%
    {\parbox[c]{\textwidth}{\centering aanwezig: \min@present}
     \parbox[c]{\textwidth}{\centering afwezig: \min@absent}}
}



\let\default@title\title
\renewcommand{\title}[1]{
    \renewcommand{\min@title}{#1}
    \default@title{#1}
}

\let\default@date\date
\renewcommand{\date}[1]{
    \renewcommand{\min@date}{#1}
    \default@date{#1}
}

\newcommand{\present}[1]{
    \renewcommand{\min@present}{#1}
}

\newcommand{\absent}[1]{
    \renewcommand{\min@absent}{#1}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here we redefine the maketitle to add attendees and other important
% information to the header.

\makeatletter
\def\@maketitle{%
    \newpage
    \null
    \vskip 2em%

    \begin{center}%
        \let \footnote \thanks
        {\LARGE \@title \par}%
        \vskip 1.5em%
        {\min@participants}% Hier stond de author en staan nu dus de af en presenten.
        \vskip 1em%
        {\large \@date}%
    \end{center}%


    \tableofcontents

    \par % empty line
    \vskip 1.5em
}
\makeatother

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



\newcommand{\wvttk}{\textsc{W.v.t.t.k.}}
\newcommand{\nameshape}{\slshape}
\newcommand{\name}[1]{{\nameshape #1}}
\newcommand{\sidenote}[1]{\medskip \footnotesize \emph{#1} \normalsize}
\newcommand{\noitemsep}{\setlength{\itemsep}{-\parskip}}
\endinput
