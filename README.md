# tex-minutes
### Introduction
The minutes class forms a standard for minutes. By including this documentclass you extend on the article class and add custom designed commands that make creating minutes more easy.

### Class loading
Using `\documentclass{<options>}{minutes}` at the top of the document you can load the class. <options> are comma seperated. At the moment this class only supports all options it inherits from the article class.

### Included commands

```latex
\title{<title of the minutes>}
% Example:
\title{Breakfast meeting}
```
Sets the title for the minutes, automatically creating the header and the footer of all pages. If no title is given, the compiler will give a PackageWarning.

```latex
\date{<date of the document>}
% Example
\date{4 November 2015}
```
Sets the date of the minutes. Remember not to use `\today`, this will cause the date to be changed on compile. If no date is given, `\today` is used and a PackageWarning is given.

```latex
\present{<list of present people>
% Example:
\present{Maico Timmerman, John Doe}
```
Sets the list of present people in the header. Output is directly added to the header.

```latex
\absent{<list of absent people>}
% Example:
\absent{Maico Timmerman, John Doe}
```
Sets the list of absent people in the header. Output is directly added to the header. If empty or not used, there will not be an entry in the `\maketitle`.

```latex
\decision{<The decision>}
% Example:
\decision{Maico will do the dishes}
```
Adds an decision to the minutes. This command also saved the decision to be used for a list of decisions.

```latex
\task{<Name>}{<Task>}
% Example:
\task{Maico Timmerman}{Do the dishes}
```
Creates a task for provided name. Can give the same task to multiple people by using comma seperated list of people. The tasks are saved internally to generated a list of tasks.

```latex
\decisionlist
```
This command generates a list of decisions made in the whole document.

```latex
\tasklist
```
This command generates a list of tasks made in the whole document. The tasks are sorted in the order they are added. Cannot be combined with `\tasklistpp`.

```latex
\tasklistpp
```
This command generates a list of tasks made in the whole document, sorted based on the name whom the task is for. Cannot be combined with `\tasklist`.

```latex
\name{<name>}
% For example
`\newcommand{\maico}{\name{Maico Timmerman}}`
```
Marks the name of a user slightly italic. Usefull for use in defining commands
for participants.

```latex
\begin{vote}{<Voting>}
    Voor & 9 stemmen\\
    Tegen & 3 stemmen\\
    Blanco & 3 stemmen\\
    Onthouden van stemmen & 3 stemmen\\
\end{vote}
```
Creates an voting table. The table must contain 2 columns seperated by `&`. The
<Voting> will be placed above the vote.
