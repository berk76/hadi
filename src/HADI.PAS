program hadi;
uses crt,graph;

type
  tsour=record
          x,y :integer;
          dx,dy :shortint;
        end;
  tplocha=object
            minx,miny,maxx,maxy :integer;
            constructor init;
            procedure kresli;
            destructor done;
          end;
  pplocha=^tplocha;
  thad=object
         barva,rychlost :byte;
         uhel :shortint;
         sour :tsour;
         mrtvo :boolean;
         doleva :byte;
         doprava :byte;
         score :word;
         constructor init(ibarva,idoleva,idoprava:byte;ix,iy:integer;iscore:word);
         procedure kresli;
         destructor done;
       end;
  phad=^thad;

var
  udalost :word;
  players :byte;
  konec :boolean;
  scklaus,sclux,sczeman :word;
  sec,xsec :word;
  min :byte;

function cara(a:tsour;uhel:word;barva:byte):boolean;
var
  tuhel :real;
  n,bar :byte;
  m :shortint;
begin
  cara:=false;
  m:=0;
  if a.dx=0 then begin
                   for n:=1 to abs(a.dy) do begin
                                              m:=m+a.dy div abs(a.dy);
                                              {putpixel(a.x,a.y+m,barva);}
                                              circle(a.x,a.y+m,1);
                                              bar:=getpixel(a.x,a.y+m+2*a.dy div abs(a.dy));
                                              if bar<>0 then begin
                                                               n:=abs(a.dy);
                                                               cara:=true;
                                                              end;
                                            end;
                  end;
  if a.dy=0 then begin
                   for n:=1 to abs(a.dx) do begin
                                              m:=m+a.dx div abs(a.dx);
                                              {putpixel(a.x+m,a.y,barva);}
                                              circle(a.x+m,a.y,1);
                                              bar:=getpixel(a.x+m+2*a.dx div abs(a.dx),a.y);
                                              if bar<>0 then begin
                                                               n:=abs(a.dx);
                                                               cara:=true;
                                                              end;
                                            end;
                 end;
  if (a.dy<>0) and (a.dx<>0) then
          begin
            tuhel:=(a.dy/a.dx);
            for n:=1 to abs(a.dx) do begin
                              m:=m+a.dx div abs(a.dx);
                              {putpixel(a.x+m,round(a.y+tuhel*m),barva);}
                              circle(a.x+m,round(a.y+tuhel*m),1);
                              bar:=getpixel(a.x+m+2*a.dx div abs(a.dx),round(a.y+tuhel*(m+2*a.dx div abs(a.dx))));
                              if bar<>0 then begin
                                               n:=abs(a.dx);
                                               cara:=true;
                                             end;
                            end;
          end;
end;

constructor tplocha.init;
begin
  minx:=0;
  miny:=0;
  maxx:=trunc(getmaxx-getmaxx*0.25);
  maxy:=getmaxy;
end;

procedure tplocha.kresli;
var
  minuty,sekundy,score :string;
begin
  setcolor(yellow);
  rectangle(minx,miny,getmaxx,getmaxy);
  setcolor(blue);
  rectangle(minx+1,miny+1,maxx-1,maxy-1);
  setcolor(yellow);
  rectangle(minx+2,miny+2,maxx-2,maxy-2);
  line(maxx,miny,maxx,maxy);
  setcolor(white);
  outtextxy(maxx+50,miny+20,'H A D I');
  outtextxy(maxx+50,miny+30,'=======');
  setcolor(darkgray);
  outtextxy(maxx+10,miny+70,'Cas:');
  if players<>0 then begin
    setcolor(black);
    setfillstyle(0,black);
    bar(maxx+55,miny+90,maxx+105,miny+100);
    setcolor(white);
    xsec:=xsec+1;
    if xsec=20 then begin
                     xsec:=0;
                     sec:=sec+1;
                     if sec=60 then begin
                                       sec:=0;
                                       min:=min+1;
                                     end;
                   end;
    str(min:2,minuty);
    str(sec:2,sekundy);
    outtextxy(maxx+55,miny+90,minuty+':'+sekundy);
  end;
  setcolor(darkgray);
  outtextxy(maxx+10,miny+120,'Score:');
  setcolor(black);
  bar(maxx+100,miny+140,getmaxx-5,miny+140+10);
  setcolor(lightblue);
  str(scklaus,score);
  outtextxy(maxx+20,miny+140,'Fiala:  ... '+score);
  setcolor(black);
  bar(maxx+100,miny+160,getmaxx-5,miny+160+10);
  setcolor(green);
  str(sclux,score);
  outtextxy(maxx+20,miny+160,'Pospisil: . '+score);
  setcolor(black);
  bar(maxx+100,miny+180,getmaxx-5,miny+180+10);
  str(sczeman,score);
  setcolor(red);
  outtextxy(maxx+20,miny+180,'Bartos: ... '+score);
  setcolor(darkgray);
  outtextxy(maxx+10,miny+300,'Ovladani:');
  setcolor(lightblue);
  outtextxy(maxx+20,miny+325,'Fiala:  ... z,x');
  setcolor(green);
  outtextxy(maxx+20,miny+340,'Pospisil: . n,m');
  setcolor(red);
  outtextxy(maxx+20,miny+355,'Bartos: ... sipky');
  setcolor(white);
  outtextxy(maxx+20,miny+390,'ESC => Konec');
  if players=0 then begin
                      setcolor(random(8));
                      outtextxy(maxx div 2 - 115,maxy div 2,'... uder do klavesy ENTER ...');
                      if udalost=3 then udalost:=1;
                    end;
  if udalost=2 then begin
                      udalost:=1;
                      konec:=true;
                    end;
end;

destructor tplocha.done;
begin
end;

constructor thad.init(ibarva,idoleva,idoprava:byte;ix,iy:integer;iscore:word);
begin
  barva:=ibarva;
  doleva:=idoleva;
  doprava:=idoprava;
  sour.x:=ix;
  sour.y:=iy;
  rychlost:=2;
  uhel:=random(12);
  mrtvo:=false;
  score:=iscore;
end;

procedure thad.kresli;
begin
   if udalost=doleva then begin
                        uhel:=uhel-1;
                        if uhel<0 then uhel:=11;
                      end;
   if udalost=doprava then begin
                        uhel:=uhel+1;
                        if uhel>12 then uhel:=1;
                      end;
   sour.dx:=round(rychlost*cos(uhel*30*pi/180));
   sour.dy:=round(rychlost*sin(uhel*30*pi/180));
   setcolor(barva);
   if players=1 then begin
                       mrtvo:=true;
                       players:=players-1;
                       score:=score+sec+60*min+50;
                     end;
   if (cara(sour,uhel*30,barva)=true) and (mrtvo=false) then
                                         begin
                                           mrtvo:=true;
                                           players:=players-1;
                                           score:=score+sec+60*min;
                                         end;
   line(sour.x,sour.y,sour.x+sour.dx,sour.y+sour.dy);
   sour.x:=sour.x+sour.dx;
   sour.y:=sour.y+sour.dy;
end;

destructor thad.done;
begin
end;


procedure hra;
var
  plocha:pplocha;
  klaus:phad;
  lux:phad;
  zeman:phad;
  tempo:byte;
  cas:word;
begin
  plocha:=new(pplocha,init);
  randomize;
  klaus:=new(phad,init(lightblue,14,15,100+random(plocha^.maxx-200),100+random(plocha^.maxy-200),scklaus));
  lux:=new(phad,init(green,16,17,100+random(plocha^.maxx-200),100+random(plocha^.maxy-200),sclux));
  zeman:=new(phad,init(red,12,13,100+random(plocha^.maxx-200),100+random(plocha^.maxy-200),sczeman));
  players:=3;
  tempo:=40;
  xsec:=0;
  sec:=0;
  min:=0;
  cas:=0;
  repeat
    plocha^.kresli;
    if klaus^.mrtvo=false then klaus^.kresli else scklaus:=klaus^.score;
    if lux^.mrtvo=false then lux^.kresli else sclux:=lux^.score;
    if zeman^.mrtvo=false then zeman^.kresli else sczeman:=zeman^.score;
    if udalost <> 1 then udalost:=0;
    if keypressed then case readkey of
                              chr(0): case readkey of
                                      chr(72): udalost:=10; {nahoru}
                                      chr(80): udalost:=11; {dolu}
                                      chr(75): udalost:=12; {doleva}
                                      chr(77): udalost:=13; {doprava}
                                      end;
                              'z':     udalost:=14; {klaus doleva}
                              'x':     udalost:=15; {klaus doprava}
                              'n':     udalost:=16; {lux doleva}
                              'm':     udalost:=17; {lux doprava}
                              chr(27): udalost:=2; {esc}
                              chr(13): udalost:=3; {enter}
                            end;
    cas:=cas+1;
    if cas=200 then begin
                      if tempo>10 then tempo:=tempo-10;
                      cas:=0;
                    end;
    delay(tempo);
  until udalost=1;
  dispose(klaus,done);
  dispose(lux,done);
  dispose(zeman,done);
  dispose(plocha,done);
end;

procedure main;
var
  ch :char;
  n :byte;
  score :word;
  xx :string;
  re :real;
begin
  konec:=false;
  cleardevice;
  setcolor(white);
  outtextxy(270,100,'H A D I');
  outtextxy(270,110,'=======');
  setcolor(darkgray);
  outtextxy(30,150,'Remake puvodni hry z roku 1998 pro soutez #hvdosdev2019 (high-voltage.cz)');
  outtextxy(30,170,'                     by berk76 (c) 1998, 2019');
  outtextxy(30,220,'Souperi: (barva,ovladani)');
  setcolor(lightblue);
  outtextxy(220,250,'Petr Fiala:    ... z,x');
  setcolor(green);
  outtextxy(220,265,'Jiri Pospisil: ... n,m');
  setcolor(red);
  outtextxy(220,280,'Ivan Bartos:   ... sipky');
  setcolor(darkgray);
  outtextxy(70,320,'... uder do nejake klavesy pro zahajeni hadobijeckeho dne ...');
  ch:=readkey;
  scklaus:=0;
  sclux:=0;
  sczeman:=0;
  for n:=1 to 5 do
  begin
    cleardevice;
    hra;
    udalost:=0;
    if konec=true then exit;
  end;
  cleardevice;
  setcolor(white);
  outtextxy(260,50,'Nejlepsi hadi:');
  setcolor(darkgray);
  rectangle(0,0,getmaxx,getmaxy);
  setcolor(yellow);
  line(100,100,100,400);
  line(100,100,97,100);
  outtextxy(20,95,'Superhad');
  line(100,250,97,250);
  outtextxy(20,245,'Mejdlohad');
  line(97,400,580,400);
  outtextxy(20,395,'Zizala');
  score:=scklaus+sclux+sczeman;
  setcolor(lightblue);
  str(scklaus,xx);
  outtextxy(130,400-round(10+scklaus/score*300),'Petr Fiala ('+xx+')');
  setcolor(green);
  str(sclux,xx);
  outtextxy(290,400-round(10+sclux/score*300),'Jiri Pospisil ('+xx+')');
  setcolor(red);
  str(sczeman,xx);
  outtextxy(430,400-round(10+sczeman/score*300),'Ivan Bartos ('+xx+')');
  setcolor(darkgray);
  outtextxy(125,450,'... N => nova hra (cokoli jineho pro odchod) ...');
  ch:=readkey;
  if ch='n' then main;
end;

var grdriver,grmode: integer;
begin
  grdriver:=detect;
  initgraph(grdriver,grmode,'c:\utility\tp\bgi');
  main;
  closegraph;
end.