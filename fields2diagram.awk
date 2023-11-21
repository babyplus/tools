BEGIN{
  FS=","
  len=len ? len : 10
  srand(systime())
  parent0=parent0 ? parent0 : rand_pro()
  parent1=parent1 ? parent1 : rand_pro()
  parent2=parent2 ? parent2 : rand_pro()
  parent3=parent3 ? parent3 : rand_pro()
  default_position_x=20
  default_position_y=20
  position["x"]=position_x ? position_x : default_position_x
  position["y"]=position_y ? position_y : default_position_y
  height=height ? height : 60
  field=""
  n_len=0
  conditions=""
  dashed=0
  territories[""]=""
  note_territory_name="note"
  colors[""]=""
  color_gray="#888888"
  url_encode_and="&amp;amp;"
  condition_pool[""]=""
  lines[""]=""
}

function rand_pro(){
  rand()
  rand()
  return rand()rand()
}

function begin_parents(parents){
  print("<mxGraphModel>")
  print("<root>")
  print("<mxCell id=\""parents[0]"\"/>")
  for(tmp=1;tmp<length(parents);tmp++)
    print("<mxCell id=\""parents[tmp]"\" parent=\""parents[0]"\"/>")
}

function end_parents(){
  print("</root>")
  print("</mxGraphModel>")
}

function calc_length(text){
  return length(text)*6
}

function new_color(text){
  colors[text]=sprintf("#%X%X%X%X%X%X",
               rand_pro()*8+6, rand_pro()*16,
               rand_pro()*8+6, rand_pro()*16,
               rand_pro()*8+6, rand_pro()*16);
  return colors[text]
}

function get_color(text){
  return colors[text] ? colors[text] : new_color(text)
}

function get_light_color(text){
  tmp_color=get_color(text)
  colors["_"text]=sprintf("#%X%c%X%c%X%c\n",strtonum("0x"substr(tmp_color, 2, 1))+2,substr(tmp_color, 3, 1),
                           strtonum("0x"substr(tmp_color, 4, 1))+2,substr(tmp_color, 5, 1),
                           strtonum("0x"substr(tmp_color, 6, 1))+2,substr(tmp_color, 7, 1))
  return colors["_"text]
}

function get_dark_color(text){
  tmp_color=get_color(text)
  colors["+"text]=sprintf("#%X%c%X%c%X%c\n",strtonum("0x"substr(tmp_color, 2, 1))-4,substr(tmp_color, 3, 1),
                           strtonum("0x"substr(tmp_color, 4, 1))-4,substr(tmp_color, 5, 1),
                           strtonum("0x"substr(tmp_color, 6, 1))-4,substr(tmp_color, 7, 1))
  return colors["+"text]
}

function polish(color,text){
  color=color ? color : get_color(text)
  return "&lt;font color=&quot;"color"&quot;&gt;"text"&lt;/font&gt;"
}

function record_named_territory(name,x1,x2,y1,y2){
  territories[name]= territories[name] ?
  territories[name] "|" x1":"x2":"y1":"y2 : x1":"x2":"y1":"y2
}

function print_a_mxCell(mxCell_args, mxGeo_args, ex){
  tmp_id=mxCell_args["id"] ? mxCell_args["id"] : mxCell_args["annotation"]rand_pro()
  tmp_value=mxCell_args["value"] ? mxCell_args["value"] : ""
  tmp_style=mxCell_args["style"] ? mxCell_args["style"] : ""
  tmp_vertex=mxCell_args["vertex"] ? mxCell_args["vertex"] : "1"
  tmp_parent=mxCell_args["parent"] ? mxCell_args["parent"] : ""
  tmp_x=mxGeo_args["x"] ? mxGeo_args["x"] : 0
  tmp_y=mxGeo_args["y"] ? mxGeo_args["y"] : 0
  tmp_w=mxGeo_args["width"] ? mxGeo_args["width"] : 1
  tmp_h=mxGeo_args["height"] ? mxGeo_args["height"] : 20
  ex["type"]=ex["type"] ? ex["type"] : "block"
  if("block"==ex["type"]){
    print("<mxCell id=\""tmp_id"\" value=\""tmp_value"\" style=\""tmp_style"\" vertex=\""tmp_vertex"\" parent=\""tmp_parent"\">")
    print("<mxGeometry x=\""tmp_x"\" y=\""tmp_y"\" width=\""tmp_w"\" height=\""tmp_h"\" as=\"geometry\" />")
    print("</mxCell>")
  }else if("line"==ex["type"]){
    print("<mxCell id=\""tmp_id"\" value=\"\" style=\""tmp_style"\" edge=\"1\" parent=\""tmp_parent"\" source=\""ex["source"]"\" target=\""ex["target"]"\">")
    print("<mxGeometry relative=\"1\" as=\"geometry\">")
    print("<mxPoint as=\"sourcePoint\" />")
    print("<mxPoint as=\"targetPoint\" />")
    print("</mxGeometry>")
    print("</mxCell>")
  }
  delete mxCell_args
  delete mxGeo_args
}

function create_a_note(parent,x,y,text,ex){
  tmp_n=split(text,tmp_list,"&")
  tmp_top=1
  tmp_height=20
  roughcast=ex["roughcast"]
  tmp_style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;"
  for(tmp_i=1;tmp_i<=tmp_n;tmp_i++){
    if(!tmp_top){
      mxCell_args["id"]="note_"rand_pro()
      mxCell_args["value"]=polish(color_gray, url_encode_and)
      mxCell_args["style"]=tmp_style
      mxCell_args["parent"]=parent
      mxGeo_args["x"]=x
      mxGeo_args["y"]=y
      print_a_mxCell(mxCell_args, mxGeo_args)
      tmp_width=8
      record_named_territory(note_territory_name,x,x+tmp_width,y,y+tmp_height)
      x+=tmp_width
    }
    tmp_value=tmp_list[tmp_i]
    tmp_width=calc_length(tmp_value)
    tmp_value= roughcast ? polish(color_gray, tmp_value) : polish("", tmp_value)
    mxCell_args["id"]="note_"rand_pro()
    mxCell_args["value"]=tmp_value
    mxCell_args["style"]=tmp_style
    mxCell_args["parent"]=parent
    mxGeo_args["x"]=x
    mxGeo_args["y"]=y
    mxGeo_args["width"]=tmp_width
    print_a_mxCell(mxCell_args, mxGeo_args)
    record_named_territory(note_territory_name,x,x+tmp_width,y,y+tmp_height)
    x+=tmp_width
    tmp_top=0
  }
}

function check_territory(name, x, y){
  tmp_c=split(territories[name],territory_list,"|")
  for(tmp_n=1;tmp_n<=tmp_c;tmp_n++){
    split(territory_list[tmp_n],xys, ":")
    tmp_x1=xys[1]
    tmp_x2=xys[2]
    tmp_y1=xys[3]
    tmp_y2=xys[4]
    if (tmp_x1<=x && x<=tmp_x2 && tmp_y1<=y && y<=tmp_y2) return 1
  }
  return 0
}

function append_arr(arrs, key, value){
  arrs[key"_n"]=arrs[key"_n"] ? arrs[key"_n"]+1 : 1
  arrs[key"_"arrs[key"_n"]]=value
}

function get_arr_len(arrs, key){
  return arrs[key"_n"]
}

function get_arr_val(arrs, key, n){
  return arrs[key"_"n]
}

function reg_line(line, type, value){
  append_arr(lines, line"_"type, value)
}

function get_endpoint(container, key, target_index, source_index){
  container["target"]=get_arr_val(lines, key"_target", target_index)
  container["source"]=get_arr_val(lines, key"_source", source_index)
}

function create_a_section(parent, position, conditions, ex){
  width=ex["len"]*ex["n_len"]
  dashed=conditions ? 1 : 0
  section_desc=ex["field"]":"ex["n_len"]
  if(calc_length(section_desc) >= width){
    y_offset=0
    do{
      y_offset-=20
    } while (check_territory(note_territory_name, position["x"], position["y"]+y_offset))
    ex["roughcast"]=1
    create_a_note(parent, position["x"], position["y"]+y_offset, section_desc, ex)
    section_desc=""
  }
  rt=mxCell_args["id"]=ex["field"]"_"rand_pro()
  mxCell_args["value"]=polish(color_gray, section_desc)
  mxCell_args["style"]="rounded=0;whiteSpace=wrap;html=1;dashed="dashed";dashPattern=1 1;strokeColor="color_gray";fillColor=" (dashed ? "#F7F7F7" : "#FFFFFF") ";"
  mxCell_args["parent"]=parent
  mxGeo_args["x"]=position["x"]
  mxGeo_args["y"]=position["y"]
  mxGeo_args["width"]=width
  mxGeo_args["height"]=ex["height"]
  print_a_mxCell(mxCell_args, mxGeo_args)
  position["x"]+=width
  return rt
}

function create_a_bus(parent, position, context, ex){
  if (bus_pool[context]) {
    return bus_pool[context]
  }
  else{
    width=ex["len"]*ex["n_len"]
    tmp_color2=get_light_color(ex["color_idx"] ? ex["color_idx"] : ex["field"])
    tmp_color3=get_dark_color(ex["color_idx"] ? ex["color_idx"] : ex["field"])
    rt=mxCell_args["id"]="bus_"rand_pro()
    mxCell_args["value"]="  "context
    mxCell_args["style"]="html=1;outlineConnect=0;fillColor="tmp_color2";strokeColor="tmp_color3";gradientDirection=north;strokeWidth=2;shape=mxgraph.networks.bus;gradientDirection=north;fontColor=#222222;perimeter=backbonePerimeter;backboneSize=20;shadow=0;sketch=0;opacity=100;fontSize=18;align=left"
    mxCell_args["parent"]=parent
    mxGeo_args["width"]=total_width+20
    mxGeo_args["x"]=default_position_x
    mxGeo_args["y"]=position["y"]+ex["y_offset"]+ex["r_offset"]*ex["NR"]
    print_a_mxCell(mxCell_args, mxGeo_args)
    bus_pool[context]=rt
    color_map[rt]=ex["color_idx"] ? ex["color_idx"] : ex["field"]
    ex["color_idx"]=""
    return rt
  }
}

function create_lines(parent, ex){
  ex["type"]="line"
  tmp_entryX=ex["entryX"] ? ex["entryX"] : 0.95
  tmp_entryY=ex["entryY"] ? ex["entryY"] : 0
  for (tmp_i=1;tmp_i<=get_arr_len(lines, ex["Lkey"]"_target");tmp_i++){
    tmp_entryX+=ex["entryX_offset"]
    for (tmp_j=1;tmp_j<=get_arr_len(lines, ex["Lkey"]"_source");tmp_j++){
      mxCell_args["id"]="line_"rand_pro()
      tmp_color=get_dark_color(ex["color_idx"])
      mxCell_args["style"]="endArrow=none;html=1;rounded=0;entryX="tmp_entryX";entryY="tmp_entryY";entryDx=0;entryDy=0;strokeColor="tmp_color";"
      mxCell_args["parent"]=parent
      get_endpoint(ex, ex["Lkey"], tmp_i, tmp_j)
      print_a_mxCell(mxCell_args, mxGeo_args, ex)
    }
  }
  ex["extryX"]=\
  ex["extryY"]=\
  ex["color_idx"]=\
  0
}

BEGIN{
  parents[0]=parent0
  parents[1]=parent1
  parents[2]=parent2
  parents[3]=parent3
  total_width=0
  begin_parents(parents)
}

{
  total_width+=$2*len
  rows[NR]=$0
}

END{
  for(tmp_NR=1;tmp_NR<=length(rows);tmp_NR++){
    split(rows[tmp_NR],tmp_columns,",")
    field=tmp_columns[1]
    n_len=tmp_columns[2]
    conditions=tmp_columns[3]
    context=tmp_columns[4]
    bus_value=field":"context
    ex["field"]=field
    ex["height"]=height
    ex["len"]=len
    ex["n_len"]=n_len
    ex["NR"]=tmp_NR
    sec_id=create_a_section(parent1, position, conditions, ex)
    ex["y_offset"]=100
    ex["r_offset"]=45
    ex["entryX"]=0.95
    ex["entryX_offset"]=-0.05
    bus_id=create_a_bus(parent2, position, bus_value, ex)
    connection=ex["field"]"_to_bus"
    reg_line(connection, "target", sec_id)
    reg_line(connection, "source", bus_id)
    ex["Lkey"]=connection
    ex["color_idx"]=field
    ex["entryY"]=1
    create_lines(parent2, ex)
    tmp_c=split(conditions,conditions_list,"&")
    if(0<tmp_c){
      ex["entryX"]=0.05
      ex["entryX_offset"]=0.05
      for(tmp_o=1;tmp_o<=tmp_c;tmp_o++){
        if (""==conditions_list[tmp_o]) continue
        ex["y_offset"]=-100
        ex["r_offset"]=-45
        tmp_idx=rand_pro()
        ex["color_idx"]=tmp_idx
        tmp_n=length(condition_pool)+1
        ex["NR"]=tmp_n
        condition_id=create_a_bus(parent3, position, conditions_list[tmp_o], ex)
        connection=ex["field"]"_to_"condition_id
        ex["Lkey"]=connection
        reg_line(connection, "target", sec_id)
        reg_line(connection, "source", condition_id)
        ex["color_idx"]=color_map[condition_id]
        ex["entryY"]=0
        condition_pool[condition_id]=condition_id
        create_lines(parent3, ex)
        ex["entryX"]+=ex["entryX_offset"]
      }
    }
  }
}

END{
  end_parents()
}

