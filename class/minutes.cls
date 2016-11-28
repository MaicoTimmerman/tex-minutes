% Copyright (C) 2015 Vereniging Informatiewetenschappen Amsterdam

\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{minutes}[2011/01/25 v1.0 via-minutes]

\newif\ifeng@art \eng@artfalse
\newif\ifcolor@art \color@arttrue

\DeclareOption{english}{\eng@arttrue}
\DeclareOption{colorblind}{\color@artfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions

\LoadClass{article}

\ifeng@art
    \RequirePackage[english]{babel}
\else
    \RequirePackage[dutch]{babel}
\fi

\RequirePackage{tabularx, geometry, marginnote, eurosym, minitoc, fancyhdr, lineno, ifthen, xspace}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage[utf8]{inputenc}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Margins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\if@twoside
    \setlength{\oddsidemargin}  {35mm}
    \setlength{\evensidemargin} {25mm}
\else
    \setlength{\oddsidemargin}  {30mm}
    \setlength{\evensidemargin} {30mm}
\fi

\setlength{\hoffset}        {-1in}
\setlength{\voffset}        {-1in}

\setlength{\marginparwidth}{30mm}

\setlength{\textwidth}      {150mm}
\setlength{\textheight}     {230mm}
\setlength{\topmargin}      {20mm}
\setlength{\headheight}     {1.5em}
\setlength{\headsep}        {2em}
\setlength{\footskip}       {4em}

\setlength{\parindent}      {0em}
\setlength{\parskip}        {0em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Page Style
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

\rightlinenumbers*
\modulolinenumbers[5]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Counter Depth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setcounter{secnumdepth}{1}
\setcounter{tocdepth}{2}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decisions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifeng@art
    \newcommand{\decisionlistname}{Decisions}
\else
    \newcommand{\decisionlistname}{Besluitenlijst}
\fi

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
    \reversemarginpar
    \ifcolor@art
        {\color{Purple}
    \fi
    \ifeng@art
            \marginnote{\small{\textbf{Decision}}}
    \else
            \marginnote{\small{\textbf{Besluit}}}
    \fi
            \textit{#1}
    \ifcolor@art
        }
    \fi
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


\ifeng@art
    \newcommand{\tasklistname}{Tasks}
\else
    \newcommand{\tasklistname}{Actiepunten}
\fi
\newcommand{\tasklistentry}{
  \addcontentsline{toc}{section}{\tasklistname}
}

% Support command. Make a tasklist after you defined a \@task command
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
    % Search all ##1 for names that are already known
    \def\splitn@@m##1, {%
        \setcounter{task@curname}{0}%
        \setboolean{task@gebakt}{false}%
        \ifx\relax##1%
            \let\next@@\relax
        \else
            \let\next@@\splitn@@m
            \whiledo{\thetask@curname < \thetask@names}{%
                \ifthenelse{\equal{##1}{\csname task@name\thetask@curname\endcsname}}{%
                    % Name found
                    % Load the other tasks this user already has
                    \setcounter{task@tmp}{\csname task@name\thetask@curname taken\endcsname}%
                    % Define \task@nameXXtaskXX as a new task:
                    \global\expandafter\def\csname task@name\thetask@curname taak\thetask@tmp\endcsname{%
                        \ifthenelse{\equal{#1}{##1}}{%
                            \l@task{#2}{#3}
                        }{%
                            \l@task{+ \verwijdern@@m{#1}{##1}: #2}{#3}
                        }
                    }%
                    % Increment the amount of tasks
                    \stepcounter{task@tmp}%
                    \global\expandafter\edef\csname task@name\thetask@curname taken\endcsname{\thetask@tmp}%

                    % Save that this name already exists
                    \setboolean{task@gebakt}{true}%
                }{%
                    % nothing
                }%
                \stepcounter{task@curname}%
            }%
            % If the name is not already known, we should define it as a new name
            \ifthenelse{\boolean{task@gebakt}}{%
            }{%
                % Initialise name, amoun of tasks (1), and the first task itself
                \global\expandafter\def\csname task@name\thetask@names\endcsname{##1}%
                \global\expandafter\edef\csname task@name\thetask@names taken\endcsname{1}%
                \global\expandafter\def\csname task@name\thetask@names taak0\endcsname{%
                    \ifthenelse{\equal{#1}{##1}}{%
                        \l@task{#2}{#3}
                    }{%
                        \l@task{+ \verwijdern@@m{#1}{##1}: #2}{#3}
                    }
                }%
                % Increment the amount of names
                \stepcounter{task@names}%
            }%
        \fi
    \next@@}%
    % Split #1 on commas
    \expandafter\splitn@@m#1, \relax,%
}%

\newcommand*{\l@task}{\@dottedtocline{1}{1.5em}{2.3em}}

% Usercommand for tasks
\newcommand{\task}[2]{\par
    \reversemarginpar
    \ifcolor@art
        {\color{Red}
    \fi
    \ifeng@art
            \marginnote{\small{\textbf{Task}}}
    \else
            \marginnote{\small{\textbf{Actie}}}
    \fi
            \@intasklisttrue
            \textit{\name{#1} #2}
    \ifcolor@art
        }
    \fi
    \addtocontents{loa}{\protect\@task{#1}{#2}{\thepage}}
    \@intasklistfalse
    \normalmarginpar
}

\newif\if@intasklist
\newcommand{\shorttaskname}[2]{%
  \ifcsname#1\endcsname%
    \ifeng@art
        \PackageError{minutes}{The command #1 already exists!}{The command #1 already exists!}
    \else
        \PackageError{minutes}{Het commando #1 bestaat al!}{Het commando #1 bestaat al!}%
    \fi
  \fi%
  \expandafter\newcommand\csname #1\endcsname{%
    \if@intasklist%
      #2%
    \else%
      \mbox{\name{#2}}\xspace%
    \fi%
  }%
}

% List of actions, not per person
\newcommand{\tasklist}{%
    \global\def\@task##1##2{\contentsline{task}{\name{##1} ##2}}%
    \task@buildtasklist%
}

% Assisting commands for \tasklistpp
\newcounter{task@names}
\newcounter{task@curname}
\newcounter{task@tmp}
\newboolean{task@gebakt}

% List of tasks; grouped by person
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
% Voting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{vote}[1]{
    \vspace{1em}
    \reversemarginpar
    \ifeng@art
        \marginnote{\small{\textbf{Voting}}}
        \textbf{Vote proposal} #1
    \else
        \marginnote{\small{\textbf{Stemming}}}
        \textbf{Stemvoorstel:} #1
    \fi
    \normalmarginpar
    \begin{center}
        \begin{tabular}{ll}
}{
        \end{tabular}
    \end{center}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Timestamps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\timestamp}[2]{\par
    \reversemarginpar
    \ifcolor@art
        {\color{OliveGreen}
    \fi
            \marginnote{\small{\textbf{#1}}}
            \textit{#2}\par
    \ifcolor@art
        }
    \fi
    \normalmarginpar
    % \sidenote{#2}
    % \marginnote{$\Leftarrow$ \footnotesize{#1}}\par
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifeng@art
    \newcommand{\min@title}{Minutes\message{Warning: no title defined}}
    \newcommand{\min@date}{\today \message{Warning: no date defined}}
    \newcommand{\min@presend}{Everyone}
\else
    \newcommand{\min@title}   {Notulen\message{Waarschuwing: geen title ingevoerd}}
    \newcommand{\min@date}   {\today \message{Waarschuwing: geen date ingevoerd}}
    \newcommand{\min@present}{Allen}
\fi

\newcommand{\min@absent}{}
\newcommand{\min@starttime}{}
\newcommand{\min@endtime}{}
\newcommand{\min@chairman}{}
\newcommand{\min@secretary}{}
\newcommand{\min@location}{}

\newcommand{\secretary}[1]{%
    \renewcommand{\min@secretary}{#1}
}

\newcommand{\chairman}[1]{%
    \renewcommand{\min@chairman}{#1}
}

\newcommand{\starttime}[1]{%
    \renewcommand{\min@starttime}{#1}
}

\newcommand{\stoptime}[1]{%
    \renewcommand{\min@endtime}{#1}
}
\newcommand{\location}[1]{%
    \renewcommand{\min@location}{#1}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Presence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifeng@art
    \newcommand{\min@participants}{
        \ifthenelse{\equal{\min@absent}{}}%
        {\parbox[c]{\textwidth}{\centering present: \min@present}}%
        {\parbox[c]{\textwidth}{\centering present: \min@present}
         \parbox[c]{\textwidth}{\centering absent: \min@absent}}
    }
\else
    \newcommand{\min@participants}{
        \ifthenelse{\equal{\min@absent}{}}%
        {\parbox[c]{\textwidth}{\centering aanwezig: \min@present}}%
        {\parbox[c]{\textwidth}{\centering aanwezig: \min@present}
         \parbox[c]{\textwidth}{\centering afwezig: \min@absent}}
    }
\fi

\let\default@title\title
\renewcommand{\title}[1]{%
    \renewcommand{\min@title}{#1}
    \default@title{#1}
}

\let\default@date\date
\renewcommand{\date}[1]{%
    \renewcommand{\min@date}{#1}
    \default@date{#1}
}

\newcommand{\present}[1]{
    \renewcommand{\min@present}{#1}
}

\newcommand{\absent}[1]{
    \renewcommand{\min@absent}{#1}
}

\ifeng@art
    \renewcommand{\ptctitle}{Subjects}
\else
    \renewcommand{\ptctitle}{Onderwerpen}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title
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
        {\large \@date}%

    \end{center}%
    \ifeng@art
        \begin{tabular}{ l l }
            \textbf{Chairman} & \min@chairman\\
            \textbf{Secretary} & \min@secretary\\
            \textbf{Time} & \min@starttime -- \min@endtime\\
            \textbf{Venue} & \min@location\\
        \end{tabular}
    \else
        \begin{tabular}{ l l }
            \textbf{Voorzitter} & \min@chairman\\
            \textbf{Notulist} & \min@secretary\\
            \textbf{Tijd} & \min@starttime -- \min@endtime\\
            \textbf{Locatie} & \min@location\\
        \end{tabular}
    \fi

    % This is where the author would be placed
    % Now replaced by the people present and absent
    {\min@participants}
    \vskip 1em%
    \rule{\linewidth}{0.2pt}
    \tableofcontents
    \rule{\linewidth}{0.2pt}

    \vskip 3em
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Useful commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifeng@art
    % Whatever Else Came To The Table
    \newcommand{\aob}{\textsc{Any other business}}
\else
    % Wat Er Verder Ter Tafel Kwam
    \newcommand{\wvttk}{\textsc{W.v.t.t.k.}}
\fi
\newcommand{\nameshape}{\slshape}
\newcommand{\name}[1]{{\nameshape #1}\xspace}
\newcommand{\sidenote}[1]{\medskip \footnotesize \emph{#1} \normalsize}
\newcommand{\noitemsep}{\setlength{\itemsep}{-\parskip}}

\makeatother
\endinput
