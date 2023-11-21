BEGIN{
  conditions["n"]=0
  annotations["n"]=0
  is_anno=0
}

function append_a_condition(c, v){
  c["n"]+=1
  c[c["n"]]=v
}

function remove_a_condition(c){
  c[c["n"]]=""
  c["n"]-=1
  if (c["n"]==-1) {
    print("warring")
    exit
  }
}

function get_current_condition(r,tmp){
  sub(/\t/, " ", r)
  if(r~"^#ifdef"){
    sub(/^#ifdef /, "", r)
    append_a_condition(conditions, r)
  }
  if(r~"^#ifndef"){
    sub(/^#ifndef /, "!", r)
    append_a_condition(conditions, r)
  }
  if(r~"^#if defined"){
    sub(/^#if /, "", r)
    append_a_condition(conditions, r)
  }
  if(r~"^#if IS_ENABLED"){
    sub(/^#if /, "", r)
    append_a_condition(conditions, r)
  }
  if(r~"^#endif"){
    remove_a_condition(conditions)
  }
  tmp_rt=""
  for (i=1;i<=conditions["n"];i++){
    tmp_rt=tmp_rt (tmp_rt ? " & " : "") conditions[i]
  }
  return tmp_rt
}

function append_a_annotation(idx, r){
  annotations[idx]=annotations[idx]""r
}

function get_annotation(idx, r){
  is_anno=(-1==is_anno) ? 0 : is_anno
  if(0!=index($0, "/*")){
    is_anno=idx
  }
  if(is_anno){
    append_a_annotation(is_anno, r)
  }
  if(0!=index($0, "*/")){
    is_anno=-1
  }
}

function get_current_field(nr, r){
  match(r, /(([0-9]|[a-z]|[A-Z]|_|\[|\])+\s?:?\s?[0-9]*\s?);/, A)
  return A[1]
}

{
  annotation=get_annotation(NR, $0)
  if(!is_anno){
    current_condition=get_current_condition($0)
    field=get_current_field(NR, $0)
    if (field) print(field ",8," current_condition",context")
  }
}

END{
}
