# This file will generate the results_display.tex file.
from re import sub

dirs = ['output/Data',
        'output/Evaluation/Books',
        'output/Evaluation/Dolls',
        'output/Evaluation/Reindeer']

f = open('results_display.tex', 'wb')

def escapeUnderscores(s):
    return sub("_", "\_", s)

def displayImage(imPath):
    code = "\subsubsection{%s}\n" % escapeUnderscores(imPath)
    code += "    \\includegraphics[scale=0.5]{%s}" % imPath
    f.write(code + "\n\n")

for d in dirs:
    sectionName = d.split("/")[-1]
    f.write("\\subsection{%s}\n" % sectionName)

    displayImage(d + "/disp1.png")
    displayImage(d + "/disp2.png")
    
    if sectionName not in ["Dolls", "Reindeer"]:
        displayImage(d + "/mse_vs_blocksize.png")
        displayImage(d + "/best_dispmap.png")
    displayImage(d + "/after_consistency_check.png")
    displayImage(d + "/dynamic_prog.png")


f.close()
