BEGIN{
  FS=","
  len=len ? len : 10
  srand(systime())
  parent0=parent0 ? parent0 : rand()
  parent1=parent1 ? parent1 : rand()
  position["x"]=position_x ? position_x : 20
  position["y"]=position_y ? position_y : 20
  height=height ? height : 60
  field=""
  n_len=0
  conditions=""
  dashed=0
  territories[""]=""
  desc_territory_name="desc"
  colors[""]=""
  color_gray="#888888"
  url_encode_and="&amp;amp;"
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
               rand()*10+4, rand()*16,
               rand()*10+4, rand()*16,
               rand()*10+4, rand()*16);
  return colors[text]
}

function get_color(text){
  return colors[text] ? colors[text] : new_color(text)
}

function polish(color,text){
  color=color ? color : get_color(text)
  return "&lt;font color=&quot;"color"&quot;&gt;"text"&lt;/font&gt;"
}

function record_named_territory(name,x1,x2,y1,y2){
  territories[name]= territories[name] ?
  territories[name] "|" x1":"x2":"y1":"y2 : x1":"x2":"y1":"y2
}

function print_a_mxCell(mxCell_args, mxGeo_args){
  tmp_id=mxCell_args["id"] ? mxCell_args["id"] : mxCell_args["annotation"]rand()
  tmp_value=mxCell_args["value"] ? mxCell_args["value"] : ""
  tmp_style=mxCell_args["style"] ? mxCell_args["style"] : ""
  tmp_vertex=mxCell_args["vertex"] ? mxCell_args["vertex"] : "1"
  tmp_parent=mxCell_args["parent"] ? mxCell_args["parent"] : ""
  tmp_x=mxGeo_args["x"] ? mxGeo_args["x"] : 0 
  tmp_y=mxGeo_args["y"] ? mxGeo_args["y"] : 0 
  tmp_w=mxGeo_args["width"] ? mxGeo_args["width"] : 1
  tmp_h=mxGeo_args["height"] ? mxGeo_args["height"] : 20
  print("<mxCell id=\""tmp_id"\" value=\""tmp_value"\" style=\""tmp_style"\" vertex=\""tmp_vertex"\" parent=\""tmp_parent"\">")
  print("<mxGeometry x=\""tmp_x"\" y=\""tmp_y"\" width=\""tmp_w"\" height=\""tmp_h"\" as=\"geometry\" />")
  print("</mxCell>")
  delete mxCell_args
  delete mxGeo_args
}

function create_a_desc(parent,x,y,text,ex){
  tmp_n=split(text,tmp_list,"&")
  tmp_top=1
  tmp_height=20
  roughcast=ex["roughcast"]
  tmp_style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;"
  for(tmp_i=1;tmp_i<=tmp_n;tmp_i++){
    if(!tmp_top){
      mxCell_args["id"]="desc_"rand()
      mxCell_args["value"]=polish(color_gray, url_encode_and)
      mxCell_args["style"]=tmp_style
      mxCell_args["parent"]=parent
      mxGeo_args["x"]=x
      mxGeo_args["y"]=y
      print_a_mxCell(mxCell_args, mxGeo_args) 
      tmp_width=8
      record_named_territory(desc_territory_name,x,x+tmp_width,y,y+tmp_height)
      x+=tmp_width
    }
    tmp_value=tmp_list[tmp_i]
    tmp_width=calc_length(tmp_value)
    tmp_value= roughcast ? polish(color_gray, tmp_value) : polish("", tmp_value)
    mxCell_args["id"]="desc_"rand()
    mxCell_args["value"]=tmp_value
    mxCell_args["style"]=tmp_style
    mxCell_args["parent"]=parent
    mxGeo_args["x"]=x
    mxGeo_args["y"]=y
    mxGeo_args["width"]=tmp_width
    print_a_mxCell(mxCell_args, mxGeo_args) 
    record_named_territory(desc_territory_name,x,x+tmp_width,y,y+tmp_height)
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

function create_a_section(parent, position, field, height, len, n_len, conditions){
  width=len*n_len
  dashed=conditions ? 1 : 0
  has_condition_desc=conditions ? 1 : 0
  section_desc=field":"n_len
  if(calc_length(section_desc) >= width){
    y_offset=0
    do{
      y_offset-=20
    } while (check_territory(desc_territory_name, position["x"], position["y"]+y_offset))
    ex["roughcast"]=1
    create_a_desc(parent, position["x"], position["y"]+y_offset, section_desc, ex)
    section_desc=""
  }
  if(has_condition_desc){
    y_offset=0
    do{
      y_offset-=20
    } while (check_territory(desc_territory_name, position["x"], position["y"]+y_offset))
    ex["roughcast"]=0
    create_a_desc(parent, position["x"], position["y"]+y_offset, conditions, ex)
  }
  mxCell_args["id"]=field"_"rand()
  mxCell_args["value"]=polish(color_gray, section_desc)
  mxCell_args["style"]="rounded=0;whiteSpace=wrap;html=1;dashed="dashed";dashPattern=1 1;"
  mxCell_args["parent"]=parent
  mxGeo_args["x"]=position["x"]
  mxGeo_args["y"]=position["y"]
  mxGeo_args["width"]=width
  mxGeo_args["height"]=height
  print_a_mxCell(mxCell_args, mxGeo_args) 
  position["x"]+=width
}

BEGIN{
  parents[0]=parent0
  parents[1]=parent1
  begin_parents(parents)
}

{
  field=$1
  n_len=$2
  conditions=$3
  create_a_section(parent1, position, field, height, len, n_len, conditions) 
}

END{
  end_parents()
}
