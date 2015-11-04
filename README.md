# tex-minutes

<!--> test-->

### Introduction
The minutes class forms a standard for minutes. By including this documentclass you extend on the article class and add custom designed commands that make creating minutes more easy.

### Class loading
Using `\documentclass{<options>}{minutes}` at the top of the document you can load the class. <options> are comma seperated. At the moment this class only supports all options it inherits from the article class.

### Included commands

`\title{<title of the minutes>}`
Sets the title for the minutes, automatically creating the header and the footer of all pages. If no title is given, the compiler will give a PackageWarning.

`\date{<date of the document>}`
Sets the date of the minutes. Remember not to use `\today`, this will cause the date to be changed on compile. If no date is given, `\today` is used and a PackageWarning is given.

`\`
`\`
`\`
`\`
