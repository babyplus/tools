BEGIN{
    global dir
    global file
    dir = dir ? dir : "."
    file = ""
    diagrams = ""
    diagram = ""
}

function print_to_file(text){ 
    global file
    print text >> file
}

function create_a_diagram(name){
    print_to_file("  <diagram name=\""name"\" id=\""name"\">")
    print_to_file("    <mxGraphModel grid=\"0\">"            )
    print_to_file("      <root>"                             )
    print_to_file("        <mxCell id=\"0\" />"              )
    print_to_file("        <mxCell id=\"1\" parent=\"0\" />" )
    print_to_file("      </root>"                            )
    print_to_file("    </mxGraphModel>"                      )
    print_to_file("  </diagram>"                             )
}

function end_old_file(){ 
    create_a_diagram("补充")
    print_to_file("</mxfile>")
}

function begin_new_file(){ 
    system("> "file)
    print_to_file("<mxfile>")
    create_a_diagram("总览")
}

{
    if ("#" == $1)
    {
        dir = $2
        system("mkdir -p "dir)
    }
    else if ("##"==$1)
    {
        global dir 
        global file 
        diagrams = $2
        if ("" != file) end_old_file()
        file = dir"/"diagrams".drawio"
        begin_new_file()
    }
    else if("###"==$1)
    {
        gsub("### ","")
        diagram = $0
        create_a_diagram(diagram)
    }
}

END{
    if("" != file) print_to_file("</mxfile>")
}
