# This file will generate the results_display.tex file.
from re import sub

dirs = ['output/Data',
        'output/Evaluation/Books',
        'output/Evaluation/Dolls',
        'output/Evaluation/Reindeer']

f = open('results_display.tex', 'w')

def escapeUnderscores(s):
    return sub("_", "\_", s)

def displayImage(imPath):
    code = "\\begin{figure}[h]"
    code += "    \\includegraphics[scale=0.5]{%s}" % imPath
    code += "    \\caption{%s}" % escapeUnderscores(imPath)
    code += "\\end{figure}"
    f.write(code + "\n")

for d in dirs:
    sectionName = d.split("/")[-1]
    f.write("\\subsection{%s}\n" % sectionName)

    displayImage(d + "/disp1.png")
    displayImage(d + "/disp2.png")
    displayImage(d + "/mse_vs_blocksize.png")
    displayImage(d + "/best_dispmap.png")
    displayImage(d + "/after_consistency_check.png")
    displayImage(d + "/dynamic_prog.png")

f.close()
