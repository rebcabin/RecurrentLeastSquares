(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 11.2' *)

(***************************************************************************)
(*                                                                         *)
(*                                                                         *)
(*  Under the Wolfram FreeCDF terms of use, this file and its content are  *)
(*  bound by the Creative Commons BY-SA Attribution-ShareAlike license.    *)
(*                                                                         *)
(*        For additional information concerning CDF licensing, see:        *)
(*                                                                         *)
(*         www.wolfram.com/cdf/adopting-cdf/licensing-options.html         *)
(*                                                                         *)
(*                                                                         *)
(***************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[      1088,         20]
NotebookDataLength[     98207,       2402]
NotebookOptionsPosition[     91105,       2279]
NotebookOutlinePosition[     91644,       2299]
CellTagsIndexPosition[     91601,       2296]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell["\.7fLinear Regression by Folding", "Title",
 CellChangeTimes->{{3.727038100871808*^9, 3.727038119380846*^9}, {
  3.727471593317396*^9, 
  3.7274715984595823`*^9}},ExpressionUUID->"5ace0943-6b58-4f04-97b4-\
1ebcfe6e2f72"],

Cell["\<\
Brian Beckman
12 Feb 2018\
\>", "Text",
 CellChangeTimes->{{3.727471602355763*^9, 
  3.7274716101393967`*^9}},ExpressionUUID->"6d6ece6d-9cb2-42e6-bc66-\
b8b248512ffd"],

Cell[CellGroupData[{

Cell["Motivating Example", "Chapter",
 CellChangeTimes->{{3.727448922904108*^9, 
  3.7274489260707684`*^9}},ExpressionUUID->"9a47724a-7c15-45fa-9bd2-\
94f09f2bf165"],

Cell[TextData[{
 "Find best-fit, unknowns ",
 Cell[BoxData[
  FormBox[
   RowBox[{"m", ",", " ", "b"}], TraditionalForm]],ExpressionUUID->
  "23d9cfff-f3b2-481a-b6b0-b0dd5f9b1280"],
 ", where ",
 Cell[BoxData[
  FormBox[
   RowBox[{"z", "\[TildeTilde]", 
    RowBox[{
     RowBox[{"m", " ", "x"}], "+", "b"}]}], TraditionalForm]],ExpressionUUID->
  "327c6fd2-96f6-4323-8eb6-291777ee6a3a"],
 ", given known data ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{
     SubscriptBox["z", "1"], ",", 
     SubscriptBox["z", "2"], ",", "\[Ellipsis]", ",", 
     SubscriptBox["z", "n"]}], ")"}], TraditionalForm]],ExpressionUUID->
  "75075c60-5e3c-42da-b661-296a1ae1ee60"],
 " and ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{
     SubscriptBox["x", "1"], ",", 
     SubscriptBox["x", "2"], ",", "\[Ellipsis]", ",", 
     SubscriptBox["x", "n"]}], ")"}], TraditionalForm]],ExpressionUUID->
  "46e64d18-1f5c-4926-95b8-33f6a7ecf798"],
 ". Write this ",
 StyleBox["system",
  FontSlant->"Italic"],
 " as a matrix equation and remember the symbols ",
 Cell[BoxData[
  FormBox["\[CapitalZeta]", TraditionalForm]],ExpressionUUID->
  "6506ca43-d29d-41ac-a6e2-79dfb4a63621"],
 " (",
 StyleBox["observations",
  FontSlant->"Italic",
  Background->RGBColor[1, 1, 0]],
 ", known), ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "fefe6189-4c2b-40bc-a442-4a207b3a6e94"],
 " (",
 StyleBox["partials",
  FontSlant->"Italic",
  Background->RGBColor[1, 1, 0]],
 ", known), and ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "5765724f-9455-410c-b18a-1b8e1a10f25e"],
 " (",
 StyleBox["model, state, unknown parameters to be estimated",
  FontSlant->"Italic"],
 "). Rows of ",
 Cell[BoxData[
  FormBox["\[CapitalZeta]", TraditionalForm]],ExpressionUUID->
  "e1f5a451-c282-4e3b-b834-f2563cf67bfe"],
 " and ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "84ee545a-a45b-43c3-ad12-365049e2f5e2"],
 " come in matched pairs."
}], "Text",
 CellChangeTimes->{{3.727038390871489*^9, 3.727038456274043*^9}, {
  3.7274311898792877`*^9, 3.727431210306458*^9}, {3.72743162057631*^9, 
  3.727431625628214*^9}, {3.727431899653804*^9, 3.727431979499525*^9}, {
  3.727432013573489*^9, 3.7274321573609333`*^9}, {3.727432239814447*^9, 
  3.7274322449709*^9}, {3.7274337661533823`*^9, 3.727433787800761*^9}, {
  3.727440517352091*^9, 3.727440560289133*^9}, {3.727471626984016*^9, 
  3.727471663001911*^9}},ExpressionUUID->"4efc0572-ddca-4f28-a511-\
c10fdcfe3c1b"],

Cell[BoxData[
 FormBox[
  RowBox[{
   SubscriptBox["\[CapitalZeta]", 
    RowBox[{"k", "\[Times]", "1"}]], "  ", "=", "  ", 
   RowBox[{
    RowBox[{"(", GridBox[{
       {
        SubscriptBox["z", "1"]},
       {
        SubscriptBox["z", "2"]},
       {"\[VerticalEllipsis]"},
       {
        SubscriptBox["z", "k"]}
      }], ")"}], "  ", "=", "  ", 
    RowBox[{
     RowBox[{
      RowBox[{
       RowBox[{"(", GridBox[{
          {
           SubscriptBox["x", "1"], "1"},
          {
           SubscriptBox["x", "2"], "1"},
          {"\[VerticalEllipsis]", "\[VerticalEllipsis]"},
          {
           SubscriptBox["x", "k"], "1"}
         }], ")"}], "\[CenterDot]", 
       RowBox[{"(", GridBox[{
          {"m"},
          {"b"}
         }], ")"}]}], " ", "+", " ", "noise"}], "  ", "=", "  ", 
     RowBox[{
      RowBox[{
       SubscriptBox["A", 
        RowBox[{"k", "\[Times]", "2"}]], "\[CenterDot]", 
       SubscriptBox["\[CapitalXi]", 
        RowBox[{"2", "\[Times]", "1"}]]}], "+", 
      RowBox[{"samples", " ", "of", " ", 
       RowBox[{"NormalDistribution", "[", 
        RowBox[{"0", ",", 
         SubscriptBox["\[Sigma]", "\[CapitalZeta]"]}], "]"}]}]}]}]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.727431219978753*^9, 3.7274313049913387`*^9}, {
  3.72743141969454*^9, 3.7274316161107063`*^9}, {3.727431991078349*^9, 
  3.727431991079677*^9}, {3.727433277603713*^9, 3.727433294425931*^9}, {
  3.727440753860702*^9, 3.7274407556831503`*^9}, {3.7274408733251953`*^9, 
  3.727440951766347*^9}, {3.727441005231421*^9, 3.727441018782874*^9}, {
  3.727471698016046*^9, 
  3.727471719286708*^9}},ExpressionUUID->"8f7e98ca-04c4-40c6-b775-\
389edb676598"],

Cell["\<\
This extends to any linear system with any number of parameters\.7f and with \
tensors in the matrix slots. \
\>", "Text",
 CellChangeTimes->{{3.72743218344071*^9, 3.727432337884823*^9}, {
  3.727449535267564*^9, 3.727449543573064*^9}, {3.7274752783628683`*^9, 
  3.727475287576037*^9}},ExpressionUUID->"0baff407-b357-4fe5-9a53-\
b4a284986262"],

Cell[CellGroupData[{

Cell["Ground Truth", "Subchapter",
 CellChangeTimes->{{3.727038130736038*^9, 3.727038133799975*^9}, {
   3.727038190200441*^9, 3.727038194262557*^9}, {3.7270382668439693`*^9, 
   3.727038273195747*^9}, 
   3.727449676637067*^9},ExpressionUUID->"d3769472-873f-41f6-8a75-\
5c85ce7936b2"],

Cell["\<\
Make some data by sampling a line specified by the following ground truth, \
then adding some noise. Run the faked data through our estimation procedures \
and see how close the estimates come to the ground truth.\
\>", "Text",
 CellChangeTimes->{{3.7274717486938457`*^9, 3.727471863121015*^9}, {
   3.727471943951993*^9, 3.727471974860942*^9}, 
   3.7274752992891693`*^9},ExpressionUUID->"418f89a4-f1e1-428a-92a9-\
9965829ed9b2"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{"groundTruth", ",", "m", ",", "b"}], "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"groundTruth", "=", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"m", ",", "b"}], "}"}], "=", 
    RowBox[{"{", 
     RowBox[{"0.5", ",", 
      RowBox[{
       RowBox[{"-", "1."}], "/", "3."}]}], "}"}]}]}], ";"}]}], "Input",
 CellChangeTimes->{{3.727038221106352*^9, 3.72703825991599*^9}, {
  3.727450214764965*^9, 
  3.727450221204816*^9}},ExpressionUUID->"f8b5fb93-6981-45b8-a388-\
c64bd439dde2"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Partials", "Subchapter",
 CellChangeTimes->{{3.727038381072097*^9, 3.7270383858220654`*^9}, 
   3.727472022244463*^9},ExpressionUUID->"93b95a60-1a08-4de3-9676-\
b562c9c7a989"],

Cell[TextData[{
 "The partials ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "9309b19a-9472-465f-84be-8ecd35011dde"],
 " are a (column) vector of co-vectors (row vectors). Each co-vector is the \
gradient of the observation model, namely of ",
 Cell[BoxData[
  FormBox[
   RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}], TraditionalForm]],
  ExpressionUUID->"24f492e1-8cbc-4b9e-85e3-f2475b30584a"],
 ", with respect to ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "32a3d80d-1e15-455e-a684-128e0a220123"],
 ", evaluated at a specific ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "482810e6-322f-4783-a84c-dc625d8b0917"],
 ". Gradients of vector functions are co-vectors, that is, linear \
transformations of vectors. This fact becomes interesting when considering \
the dual problem, below."
}], "Text",
 CellChangeTimes->{{3.727474059032774*^9, 3.727474241042626*^9}, {
  3.727475321236279*^9, 
  3.727475337122877*^9}},ExpressionUUID->"3501115a-d07f-49d0-acc5-\
11ec346ea8f5"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{"nData", ",", "min", ",", "max"}], "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  StyleBox[
   RowBox[{"nData", "=", "119"}],
   Background->RGBColor[1, 1, 0]], ";", 
  RowBox[{"min", "=", 
   RowBox[{"-", "1."}]}], ";", 
  RowBox[{"max", "=", "3."}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"ClearAll", "[", "partials", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   StyleBox["partials",
    Background->RGBColor[1, 1, 0]], "=", 
   RowBox[{"Array", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"{", 
       RowBox[{"#", ",", "1.0"}], "}"}], "&"}], ",", "nData", ",", 
     RowBox[{"{", 
      RowBox[{"min", ",", "max"}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Short", "[", 
  RowBox[{"partials", ",", "3"}], "]"}]}], "Input",
 CellChangeTimes->{{3.727038484294626*^9, 3.727038506353806*^9}, {
   3.727038672360093*^9, 3.7270386925152807`*^9}, {3.7270387298032637`*^9, 
   3.727038738723681*^9}, {3.727432689921877*^9, 3.7274327110981913`*^9}, {
   3.727445567876906*^9, 3.727445568010209*^9}, {3.7274468698582373`*^9, 
   3.727446869999188*^9}, 3.727446939266643*^9, {3.7274470220360327`*^9, 
   3.7274470231123457`*^9}, {3.727447792622075*^9, 3.7274477929568863`*^9}, {
   3.727449108405336*^9, 3.727449126986397*^9}, {3.727449270042646*^9, 
   3.727449276077201*^9}, {3.727449337024444*^9, 3.727449352022664*^9}, {
   3.7274494075242367`*^9, 3.727449431344298*^9}, {3.72744956654039*^9, 
   3.727449572786269*^9}, {3.7274496209308167`*^9, 3.727449635986744*^9}, 
   3.727449690711412*^9, {3.727449766317731*^9, 3.727449816846671*^9}, {
   3.727451747352453*^9, 3.727451747877816*^9}, 3.7274561390872173`*^9, {
   3.727462576366873*^9, 3.727462593386175*^9}, {3.727472063650128*^9, 
   3.727472063729579*^9}},ExpressionUUID->"0dad5213-f3bd-480b-b3f8-\
f477890b519d"],

Cell[BoxData[
 TagBox[
  RowBox[{"{", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"-", "1.`"}], ",", "1.`"}], "}"}], ",", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"-", "0.9661016949152542`"}], ",", "1.`"}], "}"}], ",", 
    RowBox[{"\[LeftSkeleton]", "115", "\[RightSkeleton]"}], ",", 
    RowBox[{"{", 
     RowBox[{"2.9661016949152543`", ",", "1.`"}], "}"}], ",", 
    RowBox[{"{", 
     RowBox[{"3.`", ",", "1.`"}], "}"}]}], "}"}],
  Short[#, 3]& ]], "Output",
 CellChangeTimes->{{3.727038583630406*^9, 3.727038608390233*^9}, 
   3.727038709777071*^9, 3.727038740778534*^9, 3.727055663056172*^9, 
   3.727057129327168*^9, 3.727059177376666*^9, 3.7270594202840557`*^9, 
   3.727059460469883*^9, 3.727059722172241*^9, 3.7273704074561377`*^9, 
   3.727379374177999*^9, 3.7273796189946833`*^9, 3.727382952016055*^9, 
   3.7274396353755617`*^9, 3.72744299207996*^9, 3.727443422013879*^9, 
   3.7274434527589293`*^9, 3.727444587495447*^9, 3.727444680192195*^9, 
   3.7274455717862053`*^9, 3.72744624615656*^9, 3.72744640590419*^9, 
   3.727446838013892*^9, 3.727446872924258*^9, {3.727446907842485*^9, 
   3.727447069879878*^9}, 3.727447290299449*^9, 3.727447347017867*^9, 
   3.7274478385022182`*^9, 3.727449204471116*^9, 3.7274492775476*^9, 
   3.7274496365181932`*^9, 3.727449693340242*^9, {3.727449807165443*^9, 
   3.727449817081092*^9}, 3.727449903758767*^9, 3.727450179720099*^9, 
   3.7274506510519867`*^9, 3.7274509739039373`*^9, 3.7274517486268787`*^9, 
   3.727451981813099*^9, 3.7274548446844063`*^9, 3.727455078961658*^9, 
   3.727455974394829*^9, {3.727456142033311*^9, 3.727456186089284*^9}, 
   3.72745682664186*^9, 3.727457103211014*^9, 3.727462537773409*^9, 
   3.727462600894341*^9, 3.7274720648603897`*^9, 3.727472137401977*^9, 
   3.727485510677791*^9},ExpressionUUID->"5803b2b2-1e8d-4fd9-b3ec-\
e8823736b959"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Fake Data", "Subchapter",
 CellChangeTimes->{{3.727038130736038*^9, 3.727038133799975*^9}, 
   3.727038190200441*^9},ExpressionUUID->"ed054fa9-c08b-44c6-8a7b-\
0dcd595df858"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "fake", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"fake", "[", 
    RowBox[{"n_", ",", "\[Sigma]_", ",", "A_", ",", 
     RowBox[{"{", 
      RowBox[{"m_", ",", "b_"}], "}"}]}], "]"}], ":=", "\[IndentingNewLine]", 
   
   RowBox[{"Table", "[", "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{
      RowBox[{"RandomVariate", "[", 
       RowBox[{"NormalDistribution", "[", 
        RowBox[{"0", ",", "\[Sigma]"}], "]"}], "]"}], "+", 
      RowBox[{
       RowBox[{"A", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}], 
       ".", 
       RowBox[{"{", 
        RowBox[{"m", ",", "b"}], "}"}]}]}], ",", "\[IndentingNewLine]", 
     RowBox[{"{", 
      RowBox[{"i", ",", "n"}], "}"}]}], "]"}]}], ";"}]}], "Input",
 CellChangeTimes->{{3.727447704011672*^9, 3.727447786446568*^9}, {
  3.7274490411388807`*^9, 3.727449101412051*^9}, {3.727449980043066*^9, 
  3.727449994241746*^9}, {3.727450133949367*^9, 3.727450162748006*^9}, {
  3.727451390752479*^9, 
  3.727451399962222*^9}},ExpressionUUID->"b44d5e34-efef-4f48-b9a7-\
719b68c57f20"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{"data", ",", "noiseSigma"}], "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  StyleBox[
   RowBox[{"noiseSigma", "=", "0.65"}],
   Background->RGBColor[1, 1, 0]], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   StyleBox["data",
    Background->RGBColor[1, 1, 0]], "=", 
   RowBox[{"fake", "[", 
    RowBox[{"nData", ",", "noiseSigma", ",", "partials", ",", "groundTruth"}],
     "]"}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"Short", "[", 
  RowBox[{"data", ",", "3"}], "]"}]}], "Input",
 CellChangeTimes->{{3.727038280219474*^9, 3.727038287790659*^9}, {
  3.7270383211500597`*^9, 3.72703835571806*^9}, {3.7270386358940287`*^9, 
  3.727038663927939*^9}, {3.727038747737464*^9, 3.727038876839672*^9}, {
  3.727050006302822*^9, 3.7270500110829983`*^9}, {3.727432654265699*^9, 
  3.727432659697441*^9}, {3.727432723054358*^9, 3.727432765462573*^9}, {
  3.72744344707723*^9, 3.7274434481794357`*^9}, {3.727446952499505*^9, 
  3.7274469532000103`*^9}, {3.727447283073348*^9, 3.727447284101734*^9}, {
  3.727447801831417*^9, 3.7274478305638647`*^9}, {3.72745000784216*^9, 
  3.727450013288878*^9}, {3.7274501435089684`*^9, 3.727450170037139*^9}, {
  3.727450669288356*^9, 3.727450670595593*^9}, {3.727451668943946*^9, 
  3.727451671078163*^9}, {3.7274720470935698`*^9, 
  3.727472053265984*^9}},ExpressionUUID->"e60870b5-bbd0-44ff-99a1-\
884620c764b9"],

Cell[BoxData[
 TagBox[
  RowBox[{"{", 
   RowBox[{
    RowBox[{"-", "1.3478626498456239`"}], ",", 
    RowBox[{"-", "0.20382002010625744`"}], ",", 
    RowBox[{"-", "1.3871398927342955`"}], ",", 
    RowBox[{"\[LeftSkeleton]", "114", "\[RightSkeleton]"}], ",", 
    "1.5028473116477354`", ",", "1.6197602371257513`"}], "}"}],
  Short[#, 3]& ]], "Output",
 CellChangeTimes->{
  3.7270387677851763`*^9, {3.727038867149591*^9, 3.7270388773964233`*^9}, 
   3.727055663102105*^9, 3.727057129370555*^9, 3.727059177422636*^9, 
   3.72705942033997*^9, 3.7270594605156918`*^9, 3.7270597222146673`*^9, 
   3.727370407509316*^9, 3.72737937420789*^9, 3.727379619053474*^9, 
   3.7273829520789537`*^9, {3.727432741397806*^9, 3.7274327662165937`*^9}, 
   3.7274396353972178`*^9, 3.727442992108829*^9, 3.727443422045128*^9, 
   3.727443452800355*^9, 3.727444587519507*^9, 3.72744468023639*^9, 
   3.72744557183354*^9, 3.7274462462052383`*^9, 3.727446405956995*^9, 
   3.727446838056027*^9, 3.727446872970574*^9, {3.7274469079026823`*^9, 
   3.7274470702684298`*^9}, {3.727447285361125*^9, 3.727447290697486*^9}, 
   3.727447347400682*^9, 3.727447838556155*^9, 3.727449704912554*^9, 
   3.727449903803282*^9, {3.727450008789967*^9, 3.727450014801861*^9}, 
   3.727450179801093*^9, {3.727450656921492*^9, 3.7274506714803667`*^9}, 
   3.727450973950561*^9, 3.727451671368905*^9, 3.727451987158052*^9, 
   3.727454844732745*^9, 3.727455079003149*^9, 3.7274559744493303`*^9, {
   3.727456142089485*^9, 3.7274561861436663`*^9}, 3.7274568266819696`*^9, 
   3.7274571032765923`*^9, 3.727462547831717*^9, 3.727462600948619*^9, {
   3.72747204808424*^9, 3.727472053925476*^9}, 3.727472137462739*^9, 
   3.7274855107778893`*^9},ExpressionUUID->"0dd31cc3-30d7-4f07-8af4-\
8551dd675cd4"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Model", "Subchapter",
 CellChangeTimes->{{3.727039137746358*^9, 
  3.727039138418336*^9}},ExpressionUUID->"eedd2e9d-e382-42b9-aaaf-\
e10da0f648f4"],

Cell[TextData[{
 "Try the Wolfram built-in. The estimated ",
 Cell[BoxData[
  FormBox["m", TraditionalForm]],ExpressionUUID->
  "8bb6137a-c373-4e68-859f-b628ae16677d"],
 " and ",
 Cell[BoxData[
  FormBox["b", TraditionalForm]],ExpressionUUID->
  "d7218397-fec7-4a19-834c-58cc47b9f6a1"],
 " are reasonably close to the ground truth."
}], "Text",
 CellChangeTimes->{{3.727432553517992*^9, 3.727432621798977*^9}, {
  3.727472080939521*^9, 
  3.727472088160452*^9}},ExpressionUUID->"49e9bcc9-2e31-4cd9-ba2c-\
0f6c4c682e44"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "model", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"model", "=", 
   RowBox[{
    StyleBox["LinearModelFit",
     Background->RGBColor[0.87, 0.94, 1]], "[", 
    RowBox[{
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"partials", "\[LeftDoubleBracket]", 
         RowBox[{"All", ",", "1"}], "\[RightDoubleBracket]"}], ",", "data"}], 
       "}"}], "\[Transpose]"}], ",", "\[Xi]", ",", "\[Xi]"}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Normal", "[", "model", "]"}]}], "Input",
 CellChangeTimes->{{3.7270391419515553`*^9, 3.727039222672346*^9}, {
   3.727039589022585*^9, 3.727039634463044*^9}, {3.72703984614863*^9, 
   3.7270398612337418`*^9}, {3.727432525241551*^9, 3.727432532127486*^9}, 
   3.727445246314415*^9},ExpressionUUID->"73a4e9ea-ba7d-42cc-9186-\
54c9b0ede34c"],

Cell[BoxData[
 RowBox[{
  RowBox[{"-", "0.392775334815505`"}], "+", 
  RowBox[{"0.6141132770984788`", " ", "\[Xi]"}]}]], "Output",
 CellChangeTimes->{
  3.727039636453086*^9, 3.727039861741905*^9, 3.727055663158083*^9, 
   3.727057129421227*^9, 3.727059177473164*^9, 3.727059420390205*^9, 
   3.727059460559739*^9, 3.7270597222647333`*^9, 3.727370407570586*^9, 
   3.727379374273665*^9, 3.727379619119594*^9, 3.727382952138339*^9, 
   3.727432540947384*^9, 3.7274396354423*^9, 3.727442992152419*^9, 
   3.7274434220853767`*^9, 3.727443452837515*^9, 3.7274445875622473`*^9, 
   3.727444680287569*^9, 3.7274451623174067`*^9, 3.727445248914556*^9, 
   3.7274455718832607`*^9, 3.727446246253859*^9, 3.727446406005806*^9, 
   3.7274468381061697`*^9, 3.727446873004697*^9, {3.727446907951789*^9, 
   3.7274470703496027`*^9}, 3.727447290772621*^9, 3.7274473474807863`*^9, 
   3.727447838604089*^9, 3.72744971744767*^9, 3.727449903849738*^9, 
   3.727450179854268*^9, 3.72745067894905*^9, 3.727450974002071*^9, 
   3.7274519905214252`*^9, 3.727454844781467*^9, 3.7274550790484867`*^9, 
   3.727455974499503*^9, {3.7274561421377363`*^9, 3.727456186189336*^9}, 
   3.7274568267039757`*^9, 3.727457103314196*^9, 3.727462551096787*^9, 
   3.727462600989726*^9, 3.7274721375146713`*^9, 
   3.727485510832881*^9},ExpressionUUID->"d8de669a-0595-4445-ad42-\
fa3cbecc4d98"]
}, Open  ]],

Cell["\<\
Un-comment the following line to see everything Wolfram has to say about this \
model (it\[CloseCurlyQuote]s a lot of data).\
\>", "Text",
 CellChangeTimes->{{3.727445705251766*^9, 3.727445735756525*^9}, {
   3.727446896680705*^9, 3.727446898174596*^9}, 
   3.727447110091947*^9},ExpressionUUID->"87bad75d-3ad7-4be9-a71a-\
e862138cfd62"],

Cell[BoxData[
 RowBox[{"(*", 
  RowBox[{"Association", "[", 
   RowBox[{
    RowBox[{
     RowBox[{"(", 
      RowBox[{"#", "\[Rule]", 
       RowBox[{"model", "[", "#", "]"}]}], ")"}], "&"}], "/@", 
    RowBox[{"model", "[", "\"\<Properties\>\"", "]"}]}], "]"}], 
  "*)"}]], "Input",
 CellChangeTimes->{{3.727445423183494*^9, 3.727445453352212*^9}, {
  3.727445496770472*^9, 3.727445513033325*^9}, {3.727445697132193*^9, 
  3.727445698524333*^9}, {3.727446901104203*^9, 3.727446903566482*^9}, {
  3.727453939742375*^9, 3.727453943568625*^9}, {3.727454015364012*^9, 
  3.727454016578137*^9}},ExpressionUUID->"78fa6b39-5667-4a50-97f0-\
00c839dfef0d"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Show", "[", 
  RowBox[{
   RowBox[{"ListPlot", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"partials", "\[LeftDoubleBracket]", 
        RowBox[{"All", ",", "1"}], "\[RightDoubleBracket]"}], ",", "data"}], 
      "}"}], "\[Transpose]"}], "]"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Plot", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{
        RowBox[{"m", " ", "\[Xi]"}], "+", "b"}], ",", 
       RowBox[{"model", "[", "\[Xi]", "]"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"\[Xi]", ",", "min", ",", "max"}], "}"}]}], "]"}]}], 
  "]"}]], "Input",
 CellChangeTimes->{{3.727039646243634*^9, 3.7270396697516117`*^9}, {
   3.727039719966466*^9, 3.727039823407961*^9}, 3.727447260921829*^9, {
   3.727472117984476*^9, 3.72747212110266*^9}, {3.7274729782058973`*^9, 
   3.727472978941469*^9}},ExpressionUUID->"217fe9a0-b8d1-4f7a-b5bd-\
e5ffee10a3ea"],

Cell[BoxData[
 GraphicsBox[{{{}, {{}, 
     {RGBColor[0.368417, 0.506779, 0.709798], PointSize[0.009166666666666668],
       AbsoluteThickness[1.6], PointBox[CompressedData["
1:eJw1VQlQU1cUDUkgFloXLOjgSCNQsVVBkLp0ZO7DwQhYEcQiioMMi4Nr0amI
INqhgEBbEXFEW6vIIoqCYlkElYuSAUQqm8VIEAmLhD1hC0uEJu9//kzmT+b9
d+8923vL/H7aGcjlcDinND/tm3kU+Nz/s6OSi6OYkD3HxLVnAIXWbqTcuApN
vRfYXX/Tj1O70q8V2Yxhjna5pA9t9QYcrU5Oon2BWdCGu72499JyeVyVAqv9
V0bGJPWgQXbVzSf3h5Fuj+jGlDkRBuOby6CnZJNmhxyt1osC+p8qMOzIltrg
nV2Y9+xXxaHlcqTlN31En/XhEn55H16t8OR/YdmJbvLt/50XvkDLk/s1I3Vg
xHW53EPShrT9VBtmx/ieC62Qo0hTTdUpQ3nQhGG4by++iTit6dCKK9J9tu5Z
XwiV2nInP+CEZ6wqLEiGH3ONHMqc36O+aKoniz+O2tX9plL0Dcn9O7rgMtDy
QxK0OGTA3XBJhps1HydXNCIcLxXbtbahL0MQmjVL84mdEs9q2wXXo6txV1vd
IiVeZwbAQ0dCuhPPtOPP2vHtqjHHvxgWZTTiQ9q+Akdio7+7UdyOildaAsvQ
dkn+4fCADvSiA5WgZ7nX1bhGNVJ4ufn4tNWA11GkwIvF1hrJstDrZlTCfMc3
yKEEJeKqezsWF7aMAPsfyI6OykfzWzCF+R5MbIQJuYu7Z+tBiUVe3lcrZejG
9IP6vrtDT1f3z84DnAThY35T9+y8kJapfy93oQRDGTxgxTc34TzqnsULtkV/
7B29L4czDB+w0ds0skinDli+QLwwO3WrXzMShk8wepWX+W9BLVgwfIPs2Ivy
hsLGWT2g3lea7hb/CjsYvcDKzNw8QihDVk9Qu6xzqhS3zeoNv5QHH1TdCQbW
D3DHbu7XJv/kA+sXIGkX7tu6iGAF4yfomPs7mmV3zfoNSFCjqLhXDqwfIbRx
yx59kRJYv8KuX+zj7LMRWT+DyDCjaHKfDPYxfof4itWWS9d+BDYPYO/5KkGS
KsZNTF4gUlpQUrCtHdg8gW3ts9KZFhmweYMxlXqjfVArXmTyCOik/zw6XYps
XmGV44UwbtoIULbiFRAlEgTGpQ4BldNICeFfNtccPlYLWdrlFCWsSAyvid1W
iW3pAxpFh6BeonY8bfkSKbyCIXiwJMnBefcY0O0Ow+BdFuVx22QK4lNkmh3D
EGSYufF8fxeKtXJ5anx1SlXsWJeGam152Qjccu0x9pk7AXbUAKNgcULdcXy7
DChdqlEQHjUotJknA9o+cgxCuNLm4L42aEnWEq4Cr86GqR+ic9BYq26yCmZ+
POxXY9IJdDyzcTDtvcMzr2/HmCStgcch4HBbtXloEVL6N0xA1Vmvv/TKR2Bc
O37ZBBhK13rsOCiGNfRAm4S3m/sCpNcGgbHXJESGxqfq7FIBhec/BVn9uwV+
no0goYCnYJWe+zur1ko0pIDUMP16T8g2VyW4aOHzP4HvmZfHZRkSiKQDfQKB
87kKqbgHaLxMpmFNr1eqx5+FQOlJn4YDfqUvLJc2wSq6YQb8F+be5nyogwCt
PYpn4NFvwpV9yQMsXg5Z7O7sUJP4lD0vOcSneWfoXs8hYPBzSFKIUZ5MLAFz
CohDimOC7UvsO4ExmA7p/3xJ6bvXSmDOXx0y2LMyR9DQDVTeMh0ibjqV6l0w
CJfpwFxyedB7nuX8fpYvLjEN5AQvuMIhjH+5JPlxXt30FQXLH5eELS/sKnTq
BSafPHIiUwXVH4bhFuWTR4IEHg87DHmEuR94RNj5/WCy4zV4R/nlkQ02fkeb
6iaBxs+OTyRV7bFRy4aAjnuaT0T7tzx631vP5oNPNp9P9Dl+Scbyr0tc9nmk
hQ3LgTm/dQm3PbH8jdMwq4cuqR8uGJG/VbJ50iXr9u970GnFJ0+oPnrkG2t3
HQ8TDtlNAeiR7WvnJh8AJQxTvfTIDfW3DV7pPMLch3rE4srtGnezUqByWQvI
aF2spLFfwd4nAhKc8fCg3oNPrJ4CEhh34OZdg3Fg8jqHXJ33Pj+uZwL+ByUm
wlY=
       "]]}, {}}, {}, {}, {}, {}}, {{{}, {}, 
     TagBox[
      {RGBColor[0.368417, 0.506779, 0.709798], AbsoluteThickness[1.6], 
       Opacity[1.], LineBox[CompressedData["
1:eJwVxX081HccAPDD8SO5Yg1RSyVTeZx5bO3znRQ1CkVSnYskKsp6UHGSjstC
dR7mQlvyXGioPKxvSWjhhXOccBwyDh0/T5Xjtv3xfr3X+4a4+8tTKBSX//z/
EaZRu0wmwYLRl0kFBWIsJB1XTs9KsM7D5u8eZosxI8DPeXhMgr3pPS0Zv4ux
vyu3trFTgnvb5pffSRHj4A3K5WnFEjxQZcK6dF2Mo+oGky18JHgsPv2Cg7cY
59DuHQx48REvmYd5ClXEeDJTpbs5fAJvuGKqrRE4igvytdqjX4vxtcinSaeX
j+Dt1/oMg21G8NsgHSyqG8bBnWzVbyo/YF/NkJKK2A/4jbZff6niIFaz7uHe
MB7Cs5vmV0ZG9uPs7QYWQeIBnGoXFsCI6cauFexa+1siHLnlTYPLtx14z2z3
Gub3/Xj1nyxRtn4r9jXR3pX3Ty+W6br+xTlVjz2O5DvYmXVjH6VPzr7xlXi9
50ymXK4APz4RYmuQy8VxLXqxCVs68COF0O3Afww6lsxjcmE87IRlc0UxryDa
Pzk1f7oFq3r0eVw82wj6lKrIkNBGbHQ+/QWHwwOmFW1cU6se6+XwuVF3BRBH
5a/YrF2DGxQe381a7IValwVTmncF7jvODjSOEUFJdAAdLhfhsqM3tbJ2DMHK
K7hno+4dPMbPs94/MwwMFZtNQkka7L5OkzZdHIWW0iHuAKsEohx2NPuajkNJ
9bNBy5NV0G/3wqGm4iNovmsVdjXUgJugULPo3iRwn1JL1GrrYd03/ers2Slo
a+KnX9jaBBSmtY+jzTQU5qwOtNVtheaTF0u/SpkBx/BU9bYOHuzl1KKIiVlw
bLUwymZ1gKjTUq/ReB7OeGuO2St1wbHcBCXDm5/gzOf6Z1+qu2Hm9jIIbPoM
nEZsGLFTCLaVySWOqguQsGJMMYPRD0HBypstjkvh5eujTHaFCIp/yJxWyFkE
6t1pp0MLAyBK1n0jkpeB1dhZHWuvIeBQ6efd9SkonK7+45eMD0ATlj+Qr6Wg
UPVXXO/eYaBERB2wPSeHPPd5LdVbj8BCHr14QEMeOedqlOlcHYUz3OJ4jRp5
ZBZXdvZKlxieb2UrqwcroLpH/icumY/D8j2hRtdpVBQ8alt0KHQCOo1beJer
qYj6ZFbq1PwRCjNBf4iuiDx3i5sTVCbBq9hKfe2SIlLwFlXV503CVdYfUT0F
SsjAzNko1mMK8kbW3qM5E2g/p2FnxdwU3MhgMYR7CWTqZKZ68/MUMNwnNhW5
EUh1MbXFSzoFWtXVJS4HCVRzIuDwJzkSYhIP193yJZC5ndI5azUSjlulTS27
TKAVoh3p5RtJ0LuxyonIIdA7E0w+cSVBahOu1plHoNxBg+dR+0kQTAy25RQS
KPq3hAg3TxISD5Ye3fWEQHbydOWpwyQsbXH/hVVNoHy+dK1ZAAk9rYmZCjwC
xYbb7S6KIOF5zLwfj08gP/MHNOY1EpK2+WzOEhAIhlXaXaJJ+DnbpMxeSKC5
fV30CTYJlWFNb6NGCeS/Mey8URIJKcaWiW7jBPpJ0GcrTSHh3ED6gfUSAq2J
d5S9SyPB0Pl038sZAvHmNONO3SeBKtf+8PY8gYoLmfu2PSChv3xbEOMLgX5l
DK9SzSahOijL1GyRQAFf733/PpeE1HWqszIZgez/Lr9fUEDCv0Lec4Y=
        "]]},
      Annotation[#, "Charting`Private`Tag$1338#1"]& ], 
     TagBox[
      {RGBColor[0.880722, 0.611041, 0.142051], AbsoluteThickness[1.6], 
       Opacity[1.], LineBox[CompressedData["
1:eJwB4QQe+yFib1JlAgAAAE0AAAACAAAAXH4s1P//7792JDkuNxzwv97yRxDz
9e+/agooMiEZ8L9gZ2NM5uvvv1/wFjYLFvC/ZVCaxMzX779IvPQ93w/wv24i
CLWZr++/HFSwTYcD8L+BxuOVM1/vv4QHT9qu1e+/pg6bV2e+7r8dxitY73Lv
v/CeCdvOfO2/T0PlU3Ct7r+qqRfUg8PqvzFE1Mo4Ae2/PYDfKG446L8QP6jS
YXHrv27XiAseuuW/wOLoumLp6b/FGGPgswXjv/CMpSIqQOi/9SX3EH9/4L8c
MUcbUrPmv5c6eGdghtu/yNtkk0AF5b9/KsXITSfWv0Qv7+sGX+O/GbKF4aUk
0b++fF7VLdXhv/8bUL2Ta8e/ttBJPhsq4L9fBvhMYo26v1Q9NHDSNt2/rWZv
OSanmr/hKq4kHinav6wDcj0/1a0/bCUg2PbY1r9Iv//2robBP+8TXK2QwdO/
C1XfVXZwzD9wD5CBt2fQvyx0nL6Tk9M/K7k6LRw7yr8gptWagZLYP2c76ZpL
GMS/yAOtkqP93T88rw8NKuG6v99kiGkthuE/GG/p1oLprL+0XYkXo0PkPwB6
PreY0W+/69WoN1P05j+wEje50XGoP0mCDvzNduk/nDbJ91mNuD+BREPOYi/s
P/hXi4vL9cI/4Dq+RMK57j+wLJ7XZzPJP1HYqxaum/A/IF7+oaRRzz8fHuAR
iPXxP8o6N7dj+tI/AH43X0c48z+KUqX7MxPWP85odrMTlvQ/Tl0bQXdu2T9O
k8RAfe31P3AWuMUKutw/4dc1IMwt9z+W24oo3czfP2GnjgYoifg/4MkyRhGR
4T/0kAo/ac35P/krO2dTH+M/ObqVsEcL+z9A5danvaXkP2puCCkzZPw/Bpj2
aGFN5j+vPJ7zA6b9P9JQMZmk2Oc/4ZUbxeEC/z8eA/BJIYXpP5MEXnRSJABA
brvJaT0V6z8O3rWiAsQAQOzKNqmBnew/AH2BVDlxAUDs0ydp/0buP/uoXq/i
EgJA7uIzmBzU7z9tmq+NEsICQLn14aM5wfA/uCuICBFuA0CTpXMLeZTxPwxK
ciyCDgRAbdiSKohZ8j/XLdDTebwEQAkI9Ak0L/M/q54/JOReBUCmuuKgr/bz
P1ivNhEd/gVA2hibRz+69D97haGB3KoGQM5zla5rjvU/qOgdmw5MB0DFUR3N
Z1T2P4SdhWDeTgdAIn3d19tX9j9gUu0lrlEHQIConeJPW/Y/F7y8sE1XB0A5
/x34N2L2P4aPW8aMYgdArqweIwhw9j9kNpnxCnkHQJYHIHmoi/Y/IIQUSAem
B0BnvSIl6cL2P/w4fA3XqAdAxejiL13G9j/Y7ePSpqsHQCIUozrRyfY/j1ez
XUaxB0DcaiNQudD2P/4qUnOFvAdAUBgke4ne9j/c0Y+eA9MHQDlzJdEp+vY/
uIb3Y9PVB0CWnuXbnf32P5Q7Xymj2AdA88ml5hEB9z9LpS60Qt4HQK0gJvz5
B/c/unjNyYHpB0AhziYnyhX3P5YtNY9R7AdAf/nmMT4Z9z9x4pxUIe8HQNsk
pzyyHPc/KExs38D0B0CUeydSmiP3PwQB1KSQ9wdA8qbnXA4n9z/gtTtqYPoH
QE/Sp2eCKvc/vGqjLzD9B0Cs/Wdy9i33P5cfC/X//wdACSkofWox9z8tLnAl

        "]]},
      Annotation[#, "Charting`Private`Tag$1338#2"]& ]}, {}, {}}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{None, None},
  AxesOrigin->{0, 0},
  DisplayFunction->Identity,
  Frame->{{False, False}, {False, False}},
  FrameLabel->{{None, None}, {None, None}},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLines->{None, None},
  GridLinesStyle->Directive[
    GrayLevel[0.5, 0.4]],
  ImagePadding->All,
  Method->{"CoordinatesToolOptions" -> {"DisplayFunction" -> ({
        (Identity[#]& )[
         Part[#, 1]], 
        (Identity[#]& )[
         Part[#, 2]]}& ), "CopiedValueFunction" -> ({
        (Identity[#]& )[
         Part[#, 1]], 
        (Identity[#]& )[
         Part[#, 2]]}& )}},
  PlotRange->{{-1., 3.}, {-1.8023773146673157`, 2.522899026876895}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.05], 
     Scaled[0.05]}},
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{{3.7270397600884542`*^9, 3.727039824579692*^9}, 
   3.727055663223078*^9, 3.727057129486121*^9, 3.7270591775352287`*^9, {
   3.7270594204521437`*^9, 3.727059460621175*^9}, 3.727059722329212*^9, 
   3.7273704078372583`*^9, 3.7273793744929037`*^9, 3.727379619346348*^9, 
   3.72738295235072*^9, 3.727439635504332*^9, 3.7274429922215157`*^9, 
   3.727443422152643*^9, 3.727443452894998*^9, 3.7274445876245737`*^9, 
   3.727444680345767*^9, 3.727445572187066*^9, 3.727446246645545*^9, 
   3.727446406395307*^9, 3.727446838396817*^9, {3.7274468849772997`*^9, 
   3.727447072208765*^9}, {3.72744726321743*^9, 3.727447292342368*^9}, 
   3.727447349128606*^9, 3.7274478387626667`*^9, 3.727449904022327*^9, 
   3.727450180015175*^9, 3.727454252117652*^9, 3.727454844917451*^9, 
   3.7274550791704597`*^9, 3.7274559746420507`*^9, {3.727456142274695*^9, 
   3.7274561863233337`*^9}, 3.727456826835528*^9, 3.7274571034544353`*^9, 
   3.727462557970257*^9, 3.727462601129395*^9, 3.727472137742113*^9, 
   3.727485511026442*^9},ExpressionUUID->"d45c6d61-c6fc-4a77-9dee-\
f54482d4f6ae"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Normal Equations ", "Subchapter",
 CellChangeTimes->{{3.727038154048767*^9, 3.7270381788082533`*^9}, {
  3.72737126177953*^9, 3.727371269395361*^9}, {3.7273713004742193`*^9, 
  3.727371301473422*^9}, {3.727432388690963*^9, 
  3.727432389111678*^9}},ExpressionUUID->"f63ffd1b-b86f-42d3-97fe-\
b86bf2765bc8"],

Cell[TextData[{
 "Equation 1 can be solved for a value of ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "e1070982-4510-452d-9104-4027b4282bf6"],
 " that minimizes the square error ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"J", "(", "\[CapitalXi]", ")"}], 
    OverscriptBox["=", "def"], 
    RowBox[{
     RowBox[{
      RowBox[{"(", 
       RowBox[{"\[CapitalZeta]", "-", 
        RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}]}], ")"}], 
      "\[Transpose]"}], "\[CenterDot]", 
     RowBox[{"(", 
      RowBox[{"\[CapitalZeta]", "-", 
       RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}]}], ")"}]}]}], 
   TraditionalForm]],ExpressionUUID->"a1b9d468-03dc-49c4-9943-08e96ac761de"],
 ". Because the noise ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"\[ScriptCapitalN]", "(", 
     RowBox[{"0", ",", "\[Sigma]"}], ")"}], " "}], TraditionalForm]],
  ExpressionUUID->"d2ef2ed6-3502-41a9-ab64-83e47fa693fe"],
 "has zero mean (or zero ",
 StyleBox["bias",
  FontSlant->"Italic"],
 "), The solution turns out to be exactly what one would get from naive \
algebra.  ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}], TraditionalForm]],
  ExpressionUUID->"8524cb7a-422e-4376-9160-8b30cfd59b34"],
 " is square. When it is invertible,"
}], "Text",
 CellChangeTimes->{{3.7274327843718157`*^9, 3.7274328812568607`*^9}, {
   3.7274329695492764`*^9, 3.727432987909341*^9}, {3.7274405929522963`*^9, 
   3.727440597776662*^9}, {3.7274408305087957`*^9, 3.727440834532775*^9}, {
   3.727441137039894*^9, 3.7274412589545507`*^9}, {3.727441298555641*^9, 
   3.7274413240290527`*^9}, {3.727443711138123*^9, 3.727443712008112*^9}, 
   3.727443932952423*^9, {3.7274449899160423`*^9, 3.727444993644582*^9}, {
   3.7274721541913548`*^9, 
   3.727472171381256*^9}},ExpressionUUID->"345dd050-8047-41f4-963a-\
a4ceb6821703"],

Cell[BoxData[
 FormBox[
  RowBox[{
   RowBox[{
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{
       RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}], ")"}], 
     RowBox[{"-", "1"}]], "\[CenterDot]", 
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "Z"}], "  ", "=", "  ", 
   "\[CapitalXi]"}], TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.7274329995816317`*^9, 3.727433086256638*^9}, {
   3.727440616369582*^9, 3.727440619713708*^9}, 3.727440980127179*^9, {
   3.727441064009115*^9, 3.7274410867129498`*^9}, 3.7274412680182333`*^9, {
   3.727443724893661*^9, 3.7274437756712503`*^9}, {3.727443806351503*^9, 
   3.727443813377001*^9}, 
   3.727445003473629*^9},ExpressionUUID->"d139a092-6246-44cb-9f29-\
ab5eb476d3cf"],

Cell["That gives the same answer as Wolfram\[CloseCurlyQuote]s built-in:", \
"Text",
 CellChangeTimes->{{3.72747218573221*^9, 
  3.727472199188305*^9}},ExpressionUUID->"0dc31811-95c1-4efd-a762-\
32d2cc8f4434"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"Inverse", "[", 
   RowBox[{
    RowBox[{"partials", "\[Transpose]"}], ".", "partials"}], "]"}], ".", 
  RowBox[{"partials", "\[Transpose]"}], ".", "data"}]], "Input",
 CellChangeTimes->{{3.727039915051565*^9, 3.727039947873397*^9}, {
  3.7274446395823927`*^9, 
  3.727444668828559*^9}},ExpressionUUID->"8a7bcee7-6af4-4af4-8eb7-\
cffbaf130094"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.614113277098479`", ",", 
   RowBox[{"-", "0.3927753348155049`"}]}], "}"}]], "Output",
 CellChangeTimes->{
  3.727039950530216*^9, 3.7270556632408323`*^9, 3.7270571295031*^9, 
   3.7270591775686493`*^9, 3.727059420486622*^9, {3.727059460678652*^9, 
   3.727059488023638*^9}, 3.727059722365232*^9, 3.727370407864249*^9, 
   3.727379374524898*^9, 3.727379619403*^9, 3.7273829524231453`*^9, 
   3.727439635518877*^9, 3.72744299227162*^9, 3.727443422204742*^9, 
   3.7274434529244432`*^9, 3.7274445876536283`*^9, {3.727444644095763*^9, 
   3.727444680375827*^9}, 3.727445572201291*^9, 3.7274462466755257`*^9, 
   3.727446406427293*^9, 3.727446838427972*^9, {3.727446885017421*^9, 
   3.727447072404998*^9}, 3.727447292581995*^9, 3.727447349354774*^9, 
   3.7274478387943707`*^9, 3.727449904059287*^9, 3.727450180032485*^9, 
   3.72745484494238*^9, 3.727455079217379*^9, 3.727455974674*^9, {
   3.727456142288823*^9, 3.727456186372755*^9}, 3.727456826850039*^9, 
   3.727457103498486*^9, 3.7274626011682777`*^9, 3.7274721377771683`*^9, 
   3.7274855110572844`*^9},ExpressionUUID->"48e8ef42-ca92-4c16-85a5-\
065038bfee26"]
}, Open  ]],

Cell[TextData[{
 "The matrix ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{
       RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}], ")"}], 
     RowBox[{"-", "1"}]], "\[CenterDot]", 
    RowBox[{"A", "\[Transpose]"}]}], TraditionalForm]],ExpressionUUID->
  "04ef20b8-51b5-460f-b822-21c6e642d720"],
 " is the ",
 StyleBox["Moore-Penrose left pseudoinverse",
  FontSlant->"Italic"],
 ". Wolfram has a built-in for it:"
}], "Text",
 CellChangeTimes->{{3.727433101666657*^9, 
  3.727433150009388*^9}},ExpressionUUID->"9002b9aa-3e15-43a9-a7b4-\
b03717f1e09c"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{
   StyleBox["PseudoInverse",
    Background->RGBColor[0.87, 0.94, 1]], "[", "partials", "]"}], ".", 
  "data"}]], "Input",
 CellChangeTimes->{{3.7273712853724957`*^9, 
  3.727371293874542*^9}},ExpressionUUID->"fdc259c6-bf44-4e06-9498-\
995f3df82972"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.6141132770984787`", ",", 
   RowBox[{"-", "0.39277533481550475`"}]}], "}"}]], "Output",
 CellChangeTimes->{
  3.7273712944857807`*^9, 3.727379374585855*^9, 3.7273796194663477`*^9, 
   3.727382952487862*^9, 3.7274396355559683`*^9, 3.727442992319318*^9, 
   3.727443422251007*^9, 3.7274434529627523`*^9, 3.7274445876951447`*^9, 
   3.727444680417789*^9, 3.7274455722476873`*^9, 3.727446246720119*^9, 
   3.72744640647122*^9, 3.727446838471692*^9, {3.727446885072898*^9, 
   3.727447072503195*^9}, 3.727447292697041*^9, 3.7274473494713697`*^9, 
   3.727447838830246*^9, 3.7274499040967627`*^9, 3.727450180082849*^9, 
   3.727454844964015*^9, 3.727455079266862*^9, 3.727455974717*^9, {
   3.727456142338996*^9, 3.727456186421357*^9}, 3.7274568268760567`*^9, 
   3.727457103548245*^9, 3.7274626012243567`*^9, 3.727472137829957*^9, 
   3.7274855111041203`*^9},ExpressionUUID->"1656a4a6-a5c0-44dc-8c5b-\
2896007d1d97"]
}, Open  ]],

Cell[TextData[{
 Cell[BoxData[
  FormBox[
   RowBox[{
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{
       RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}], ")"}], 
     RowBox[{"-", "1"}]], "\[CenterDot]", 
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "\[CapitalZeta]"}], 
   TraditionalForm]],ExpressionUUID->"d629675c-f1af-4371-900e-61ae690a0095"],
 " is a very nasty computation, in memory usage, in time, and in numerical \
risk. Eliminate these defects with a recurrence. This recurrence is \
mathematically identical to a Kalman filter in parameter-estimation mode, \
though we do not prove that here."
}], "Text",
 CellChangeTimes->{{3.727472215578988*^9, 3.727472331662753*^9}, {
  3.727472374436943*^9, 3.727472378052897*^9}, {3.727475400731699*^9, 
  3.727475478400813*^9}},ExpressionUUID->"66c60d03-b798-439e-9aa2-\
f6362b8564d0"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Recurrence", "Chapter",
 CellChangeTimes->{{3.7270402093685093`*^9, 3.727040216990353*^9}, {
  3.72744887906024*^9, 
  3.727448879173937*^9}},ExpressionUUID->"a3f5d0f2-9fe9-4c7f-8c3f-\
d141fcc2b151"],

Cell[TextData[{
 StyleBox["Fold",
  FontSlant->"Italic"],
 " the following recurrence over ",
 Cell[BoxData[
  FormBox["\[CapitalZeta]", TraditionalForm]],ExpressionUUID->
  "604c3712-17a2-49f9-be34-dd3b93db078a"],
 " and ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "cf261e04-8ab6-46fc-8bda-0e7b27452129"],
 ":"
}], "Text",
 CellChangeTimes->{{3.7274333353229113`*^9, 3.727433378179881*^9}, {
  3.7274334464649353`*^9, 3.727433551754867*^9}, {3.727433834133542*^9, 
  3.727433857990193*^9}, {3.7274406408677483`*^9, 3.727440686530654*^9}, {
  3.7274413441593647`*^9, 3.7274413518281183`*^9}, {3.727472397267685*^9, 
  3.727472404763022*^9}, {3.727475498217351*^9, 
  3.727475507311516*^9}},ExpressionUUID->"478b59b4-7382-40c1-baf5-\
5a8f8048af58"],

Cell[BoxData[{
 FormBox[
  RowBox[{"\[Psi]", "\[LeftArrow]", 
   RowBox[{
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{"\[CapitalLambda]", "+", 
       RowBox[{
        RowBox[{"a", "\[Transpose]"}], "\[CenterDot]", "a"}]}], ")"}], 
     RowBox[{"-", "1"}]], "\[CenterDot]", 
    RowBox[{"(", 
     RowBox[{
      RowBox[{
       RowBox[{"a", "\[Transpose]"}], "\[CenterDot]", "\[Zeta]"}], "+", 
      RowBox[{"\[CapitalLambda]", "\[CenterDot]", "\[Psi]"}]}], ")"}]}]}], 
  TraditionalForm], "\[IndentingNewLine]", 
 FormBox[
  RowBox[{"\[CapitalLambda]", "\[LeftArrow]", 
   RowBox[{"(", 
    RowBox[{"\[CapitalLambda]", "+", 
     RowBox[{
      RowBox[{"a", "\[Transpose]"}], "\[CenterDot]", "a"}]}], ")"}]}], 
  TraditionalForm]}], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.7274335859903107`*^9, 3.727433717944153*^9}, {
  3.727435926163211*^9, 3.7274359787146387`*^9}, {3.7274435816067543`*^9, 
  3.7274435995641823`*^9}, {3.727443898455867*^9, 
  3.727443902554981*^9}},ExpressionUUID->"19ba13ba-a838-4929-be4d-\
043d72be3f34"],

Cell[TextData[{
 "where ",
 Cell[BoxData[
  FormBox["\[Psi]", TraditionalForm]],ExpressionUUID->
  "84ecfef9-a385-4ee2-835c-20343526e4eb"],
 " is the current estimate of \[CapitalXi], ",
 Cell[BoxData[
  FormBox["a", TraditionalForm]],ExpressionUUID->
  "41864a27-6f36-420e-b645-2927d78e3708"],
 " and ",
 Cell[BoxData[
  FormBox["\[Zeta]", TraditionalForm]],ExpressionUUID->
  "2b565737-a5ee-44e7-8efe-f18183bf67de"],
 " are matched rows of ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "6b37a4e5-effb-4aee-9c93-86475a33aa78"],
 " and ",
 Cell[BoxData[
  FormBox["\[CapitalZeta]", TraditionalForm]],ExpressionUUID->
  "fd030f9e-1732-4ac1-8aec-397d5675748d"],
 ", and ",
 Cell[BoxData[
  FormBox["\[CapitalLambda]", TraditionalForm]],ExpressionUUID->
  "87eb8a64-1e2e-4913-8996-51feec2cb0a3"],
 " accumulates ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}], TraditionalForm]],
  ExpressionUUID->"7020e26d-692e-481d-8e10-cda9feb1b0b2"],
 ". "
}], "Text",
 CellChangeTimes->{{3.727433690566415*^9, 3.727433691990076*^9}, {
   3.727433722702998*^9, 3.727433752037438*^9}, {3.727433801728943*^9, 
   3.727433813439355*^9}, {3.727435879529455*^9, 3.727435920139254*^9}, {
   3.7274395624863253`*^9, 3.72743960583661*^9}, {3.727439679294853*^9, 
   3.727439942216538*^9}, {3.727440429170088*^9, 3.727440449936098*^9}, {
   3.727440693988052*^9, 3.727440706787099*^9}, {3.727442440538804*^9, 
   3.7274424436438828`*^9}, {3.727443225488162*^9, 3.727443283700737*^9}, {
   3.727443629007498*^9, 3.727443630821762*^9}, {3.727445076605159*^9, 
   3.7274450788697367`*^9}, {3.727454527614051*^9, 3.727454553816103*^9}, {
   3.7274545955114317`*^9, 3.727454595511548*^9}, {3.7274546866285877`*^9, 
   3.727454763133893*^9}, {3.727455239597176*^9, 3.727455255845674*^9}, {
   3.7274553253206472`*^9, 3.727455326184396*^9}, 3.727455653598051*^9, {
   3.727472422563363*^9, 3.7274724518468323`*^9}, {3.7274743159268417`*^9, 
   3.7274743397668333`*^9}, {3.727475519390863*^9, 
   3.727475555533572*^9}},ExpressionUUID->"3f4d84a0-fd27-47b3-b226-\
743e281da7e5"],

Cell[TextData[{
 "Derive the recurrence as follows: Treat the estimate-so-far, ",
 Cell[BoxData[
  FormBox["\[Psi]", TraditionalForm]],ExpressionUUID->
  "d274467b-2941-449e-a71e-d573e8d430df"],
 ", as just one more observation with information matrix (proportional to \
inverse covariance) ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalLambda]", "=", 
    RowBox[{
     RowBox[{
      SubscriptBox["A", 
       RowBox[{"so", "-", "far"}]], "\[Transpose]"}], "\[CenterDot]", 
     SubscriptBox["A", 
      RowBox[{"so", "-", "far"}]]}]}], TraditionalForm]],ExpressionUUID->
  "99d71a77-4490-488a-a41d-817a38c3f3bd"],
 ". The scalar ",
 StyleBox["performance",
  FontSlant->"Italic"],
 " or ",
 StyleBox["squared error",
  FontSlant->"Italic"],
 " of the estimate, so far, is ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"J", "(", "x", ")"}], "=", 
    RowBox[{
     RowBox[{
      RowBox[{
       RowBox[{"(", 
        RowBox[{"z", "-", 
         RowBox[{
          SubscriptBox["A", 
           RowBox[{"so", "-", "far"}]], "\[CenterDot]", "x"}]}], ")"}], 
       "\[Transpose]"}], "\[CenterDot]", 
      RowBox[{"(", 
       RowBox[{"z", "-", 
        RowBox[{
         SubscriptBox["A", 
          RowBox[{"so", "-", "far"}]], "\[CenterDot]", "x"}]}], ")"}]}], "=", 
     
     RowBox[{
      RowBox[{
       RowBox[{"(", 
        RowBox[{"x", "-", "\[Psi]"}], ")"}], "\[Transpose]"}], "\[CenterDot]",
       "\[CapitalLambda]", "\[CenterDot]", 
      RowBox[{"(", 
       RowBox[{"x", "-", "\[Psi]"}], ")"}]}]}]}], TraditionalForm]],
  ExpressionUUID->"4e110243-98ab-4ecd-b721-bd0c55de58b4"],
 ", where ",
 Cell[BoxData[
  FormBox["x", TraditionalForm]],ExpressionUUID->
  "0911c97e-4ce8-4999-863c-30efc0822ef1"],
 " is the unknown true parameter vector and ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalLambda]", "=", 
    RowBox[{
     RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}]}], 
   TraditionalForm]],ExpressionUUID->"64a64f97-d4ae-4149-9dad-8aaf685bbb3f"],
 ". Adding a new observation, ",
 Cell[BoxData[
  FormBox["\[Zeta]", TraditionalForm]],ExpressionUUID->
  "b80de6f5-3ed2-4ba4-8265-5873f2a46836"],
 " and its corresponding partial ",
 Cell[BoxData[
  FormBox["a", TraditionalForm]],ExpressionUUID->
  "18ece129-4d60-461f-a203-60bbd7e8b8d2"],
 ", increases the error by ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     RowBox[{"(", 
      RowBox[{"\[Zeta]", "-", 
       RowBox[{"a", "\[CenterDot]", "x"}]}], ")"}], "\[Transpose]"}], 
    "\[CenterDot]", 
    RowBox[{"(", 
     RowBox[{"\[Zeta]", "-", 
      RowBox[{"a", "\[CenterDot]", "x"}]}], ")"}]}], TraditionalForm]],
  ExpressionUUID->"58723d93-9ece-476d-afae-807027864472"],
 ". Minimizing the new total error with respect to ",
 Cell[BoxData[
  FormBox["x", TraditionalForm]],ExpressionUUID->
  "a5012d38-e500-45b2-9665-7273a81479fa"],
 " yields the recurrence."
}], "Text",
 CellChangeTimes->{{3.727433690566415*^9, 3.727433691990076*^9}, {
   3.727433722702998*^9, 3.727433752037438*^9}, {3.727433801728943*^9, 
   3.727433813439355*^9}, {3.727435879529455*^9, 3.727435920139254*^9}, {
   3.7274395624863253`*^9, 3.72743960583661*^9}, {3.727439679294853*^9, 
   3.727439942216538*^9}, {3.727440429170088*^9, 3.727440449936098*^9}, {
   3.727440693988052*^9, 3.727440706787099*^9}, {3.727442440538804*^9, 
   3.7274424436438828`*^9}, {3.727443225488162*^9, 3.727443283700737*^9}, {
   3.727443629007498*^9, 3.727443630821762*^9}, {3.727445076605159*^9, 
   3.7274450788697367`*^9}, {3.727454527614051*^9, 3.727454553816103*^9}, {
   3.7274545955114317`*^9, 3.727454595511548*^9}, {3.7274546866285877`*^9, 
   3.727454763133893*^9}, {3.727455239597176*^9, 3.727455255845674*^9}, {
   3.7274553253206472`*^9, 3.727455326184396*^9}, 3.727455653598051*^9, {
   3.727472422563363*^9, 3.7274724518468323`*^9}, {3.7274743159268417`*^9, 
   3.727474381777117*^9}, {3.7274744338469057`*^9, 3.727474441826235*^9}, {
   3.727474630428966*^9, 3.727474631651125*^9}, {3.727474814968113*^9, 
   3.7274748698817673`*^9}, {3.727475577962327*^9, 
   3.7274756335231857`*^9}},ExpressionUUID->"53f1126b-e199-4222-9325-\
93c4e7bfc144"],

Cell[TextData[{
 "The initial value of ",
 Cell[BoxData[
  FormBox["\[Psi]", TraditionalForm]],ExpressionUUID->
  "ceef2279-86e9-4d79-9c66-b0090eec7e0b"],
 " does not matter much, but the initial value of ",
 Cell[BoxData[
  FormBox["\[CapitalLambda]", TraditionalForm]],ExpressionUUID->
  "79fa782c-af91-4421-9fd1-d388c10e03f9"],
 " cannot be singular. For practical purposes, any ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalLambda]", "0"], TraditionalForm]],ExpressionUUID->
  "0ee90124-ec70-4933-a3ce-dee8b04174ff"],
 " with terms much smaller than typical terms in ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     SubscriptBox["A", 
      RowBox[{"so", "-", "far"}]], "\[Transpose]"}], "\[CenterDot]", 
    SubscriptBox["A", 
     RowBox[{"so", "-", "far"}]]}], TraditionalForm]],ExpressionUUID->
  "97390b25-263d-45ef-8a96-9ecdbcbc4bd3"],
 " will do. The example below starts with ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[Psi]", "0"], "=", 
    RowBox[{
     RowBox[{"(", GridBox[{
        {"0", "0"}
       }], ")"}], "\[Transpose]"}]}], TraditionalForm]],ExpressionUUID->
  "677ae654-4473-448f-a107-621af1d405bd"],
 " and ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[CapitalLambda]", "0"], "=", 
    RowBox[{"(", 
     RowBox[{
      RowBox[{"(", GridBox[{
         {
          SuperscriptBox["10", 
           RowBox[{"-", "6"}]], "0"}
        }], ")"}], 
      RowBox[{"(", GridBox[{
         {"0", 
          SuperscriptBox["10", 
           RowBox[{"-", "6"}]]}
        }], ")"}]}], ")"}]}], TraditionalForm]],ExpressionUUID->
  "3bcc20f6-fa88-47cf-bc24-f6fa5579c562"],
 ". "
}], "Text",
 CellChangeTimes->{{3.727433690566415*^9, 3.727433691990076*^9}, {
   3.727433722702998*^9, 3.727433752037438*^9}, {3.727433801728943*^9, 
   3.727433813439355*^9}, {3.727435879529455*^9, 3.727435920139254*^9}, {
   3.7274395624863253`*^9, 3.72743960583661*^9}, {3.727439679294853*^9, 
   3.727439942216538*^9}, {3.727440429170088*^9, 3.727440449936098*^9}, {
   3.727440693988052*^9, 3.727440706787099*^9}, {3.727442440538804*^9, 
   3.7274424436438828`*^9}, {3.727443225488162*^9, 3.727443283700737*^9}, {
   3.727443629007498*^9, 3.727443630821762*^9}, {3.727445076605159*^9, 
   3.7274450788697367`*^9}, {3.727454527614051*^9, 3.727454553816103*^9}, {
   3.7274545955114317`*^9, 3.727454595511548*^9}, {3.7274546866285877`*^9, 
   3.727454763133893*^9}, {3.727455239597176*^9, 3.727455255845674*^9}, {
   3.7274553253206472`*^9, 3.727455326184396*^9}, 3.727455653598051*^9, {
   3.727472422563363*^9, 3.7274724518468323`*^9}, {3.727475653063583*^9, 
   3.727475668421556*^9}},ExpressionUUID->"b2e375f6-adc4-4d32-b5e5-\
8d4274e82eb3"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "update", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"update", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"\[Psi]_", ",", "\[CapitalLambda]_"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"\[Zeta]_", ",", "a_"}], "}"}]}], "]"}], ":=", 
   "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"\[CapitalPi]", "=", 
       RowBox[{"(", 
        RowBox[{"\[CapitalLambda]", "+", 
         RowBox[{
          RowBox[{"a", "\[Transpose]"}], ".", "a"}]}], ")"}]}], "}"}], ",", 
     "\[IndentingNewLine]", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{
        RowBox[{"Inverse", "[", "\[CapitalPi]", "]"}], ".", 
        RowBox[{"(", 
         RowBox[{
          RowBox[{
           RowBox[{"a", "\[Transpose]"}], ".", "\[Zeta]"}], "+", " ", 
          RowBox[{"\[CapitalLambda]", ".", "\[Psi]"}]}], ")"}]}], ",", 
       "\[CapitalPi]"}], "}"}]}], "]"}]}], ";"}], "\n", 
 RowBox[{"MatrixForm", "/@", "\[IndentingNewLine]", 
  RowBox[{"(", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"(", GridBox[{
         {"mBar"},
         {"bBar"}
        }], ")"}], ",", "\[CapitalPi]"}], "}"}], "=", 
    RowBox[{"Fold", "[", 
     RowBox[{"update", ",", "\[IndentingNewLine]", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"(", GridBox[{
           {"0"},
           {"0"}
          }], ")"}], ",", 
        RowBox[{"(", GridBox[{
           {"1.0*^-6", "0"},
           {"0", "1.0*^-6"}
          }], ")"}]}], "}"}], ",", "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"List", "/@", "data"}], ",", 
         RowBox[{"List", "/@", "partials"}]}], "}"}], "\[Transpose]"}]}], 
     "]"}]}], ")"}]}]}], "Input",
 CellChangeTimes->{{3.727054852495049*^9, 3.72705494257406*^9}, {
   3.727055026792467*^9, 3.727055093506559*^9}, {3.7270551930291023`*^9, 
   3.727055263833913*^9}, {3.727055297216107*^9, 3.7270554270906563`*^9}, {
   3.7270560338846903`*^9, 3.72705612788085*^9}, {3.7270561855129213`*^9, 
   3.7270561959544077`*^9}, {3.727056250031129*^9, 3.727056367103942*^9}, {
   3.727056427865035*^9, 3.727056443080068*^9}, {3.727056561323501*^9, 
   3.727056598046468*^9}, {3.727056640141169*^9, 3.727056654582451*^9}, {
   3.727056728700244*^9, 3.7270567914565277`*^9}, {3.727056869366274*^9, 
   3.727056921039433*^9}, 3.72705709924362*^9, {3.727057420502048*^9, 
   3.7270575464285316`*^9}, {3.7270577446377487`*^9, 3.727057775909028*^9}, {
   3.7270578799866133`*^9, 3.727057901007744*^9}, 3.7270581603330593`*^9, {
   3.727058349930079*^9, 3.7270584478842707`*^9}, {3.727058490337566*^9, 
   3.727058577824399*^9}, {3.727058673744141*^9, 3.7270586947547493`*^9}, {
   3.727058788099071*^9, 3.7270588909590683`*^9}, {3.727058934322414*^9, 
   3.7270589393580847`*^9}, {3.72705898616982*^9, 3.7270589868650723`*^9}, {
   3.7270592331231947`*^9, 3.727059237300102*^9}, {3.7274435231168203`*^9, 
   3.727443546500602*^9}, {3.727443876120749*^9, 3.7274438848810577`*^9}, {
   3.727444759010458*^9, 3.727444822403467*^9}, {3.727444904584729*^9, 
   3.727444917600658*^9}, {3.727444951170147*^9, 3.72744495624857*^9}, {
   3.727455276322372*^9, 3.7274553027713842`*^9}, {3.727455828581184*^9, 
   3.727455858661305*^9}, {3.7274561810931997`*^9, 3.727456183162497*^9}, {
   3.727472496770452*^9, 3.727472540592374*^9}, {3.727472571262414*^9, 
   3.7274725926081057`*^9}, {3.727473460371025*^9, 
   3.727473470385874*^9}},ExpressionUUID->"1dd3c95c-36ff-4723-80bc-\
7414ec3492f4"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.6141132708580754`"},
       {
        RowBox[{"-", "0.39277532527431136`"}]}
      },
      GridBoxAlignment->{
       "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, 
        "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
      GridBoxSpacings->{"Columns" -> {
          Offset[0.27999999999999997`], {
           Offset[0.7]}, 
          Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
          Offset[0.2], {
           Offset[0.4]}, 
          Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
    Function[BoxForm`e$, 
     MatrixForm[BoxForm`e$]]], ",", 
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"280.35593320338984`", "119.`"},
       {"119.`", "119.000001`"}
      },
      GridBoxAlignment->{
       "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, 
        "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
      GridBoxSpacings->{"Columns" -> {
          Offset[0.27999999999999997`], {
           Offset[0.7]}, 
          Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
          Offset[0.2], {
           Offset[0.4]}, 
          Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
    Function[BoxForm`e$, 
     MatrixForm[BoxForm`e$]]]}], "}"}]], "Output",
 CellChangeTimes->{{3.727472529149095*^9, 3.727472541371006*^9}, {
   3.727472582072073*^9, 3.727472596728858*^9}, 3.72747347227721*^9, 
   3.727485511156743*^9},ExpressionUUID->"af9a9559-08b7-40aa-b836-\
40d7292d27e9"]
}, Open  ]],

Cell[TextData[{
 "The estimates ",
 Cell[BoxData[
  FormBox["mBar", TraditionalForm]], "Code",ExpressionUUID->
  "ace851a5-9f4d-49ce-a0fa-1ee094af68d5"],
 " and ",
 Cell[BoxData[
  FormBox["bBar", TraditionalForm]], "Code",ExpressionUUID->
  "1f76bfd3-e9db-47db-a0f3-738e5d40384b"],
 " are exactly what we got from Wolfram\[CloseCurlyQuote]s built-in."
}], "Text",
 CellChangeTimes->{{3.727455669635949*^9, 3.727455714844105*^9}, {
  3.727456293561727*^9, 3.727456338621636*^9}, {3.727456381984915*^9, 
  3.727456493199937*^9}, {3.7274567040936413`*^9, 3.727456704869124*^9}, {
  3.727456739701139*^9, 3.72745677855204*^9}, {3.727472821547103*^9, 
  3.727472872838442*^9}},ExpressionUUID->"8fcdd69f-b4e8-4721-9d73-\
12a24e8e0e37"],

Cell[TextData[{
 "The mappings of ",
 Cell[BoxData[
  FormBox["List", TraditionalForm]], "Code",ExpressionUUID->
  "370d0a8b-9c99-495c-8b0f-e38240d3f06a"],
 " over the data and partials convert them into column vectors, as required \
by the recurrences in linear-algebra form."
}], "Text",
 CellChangeTimes->{{3.727473114735071*^9, 3.727473196429072*^9}, 
   3.727475691841303*^9},ExpressionUUID->"4b4359a3-6055-499b-ac58-\
8e1aa441c02b"],

Cell[TextData[{
 "The final value of ",
 Cell[BoxData[
  FormBox["\[CapitalLambda]", TraditionalForm]],ExpressionUUID->
  "39d494bd-234a-46ce-b910-d7f503d343eb"],
 ", called ",
 Cell[BoxData[
  FormBox["\[CapitalPi]", TraditionalForm]],ExpressionUUID->
  "8c23b7e5-b715-408b-91a1-2fb52b1f7699"],
 " in the code, is ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     RowBox[{
      SubscriptBox["A", "full"], "\[Transpose]"}], "\[CenterDot]", 
     SubscriptBox["A", "full"]}], "+", 
    SubscriptBox["\[CapitalLambda]", "0"]}], TraditionalForm]],
  ExpressionUUID->"1891af79-d866-486f-a629-9b2b77a22d21"],
 " "
}], "Text",
 CellChangeTimes->{{3.727455669635949*^9, 3.727455714844105*^9}, {
  3.727456293561727*^9, 3.727456338621636*^9}, {3.727456381984915*^9, 
  3.727456493199937*^9}, {3.7274567040936413`*^9, 3.727456704869124*^9}, {
  3.727456739701139*^9, 3.72745677855204*^9}, {3.727472821547103*^9, 
  3.727472866769026*^9}, {3.72747570063941*^9, 
  3.72747570624365*^9}},ExpressionUUID->"3bb9b24c-61c4-48e5-8583-\
e29da01c7bc2"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"\[CapitalPi]", "-", 
  RowBox[{
   RowBox[{"partials", "\[Transpose]"}], ".", "partials"}]}]], "Input",
 CellChangeTimes->{{3.7274551709419003`*^9, 3.727455208922634*^9}, {
  3.727455747486219*^9, 
  3.727455758602953*^9}},ExpressionUUID->"943cc4cd-72ef-4598-a22e-\
58c38092ac57"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"9.999999974752427`*^-7", ",", "0.`"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"0.`", ",", "9.999999974752427`*^-7"}], "}"}]}], "}"}]], "Output",\

 CellChangeTimes->{{3.72745518631077*^9, 3.7274552106865807`*^9}, {
   3.7274552828550367`*^9, 3.727455294638937*^9}, 3.727455760140656*^9, {
   3.72745583557261*^9, 3.7274558626374598`*^9}, 3.727455974817852*^9, {
   3.7274561424375877`*^9, 3.7274561865312757`*^9}, 3.727456826962592*^9, 
   3.727457103648644*^9, 3.7274626013231*^9, 3.727472137933955*^9, 
   3.727485511219474*^9},ExpressionUUID->"d7d56f77-073d-4ec6-a001-\
f8af4f456d06"]
}, Open  ]],

Cell[TextData[{
 "The covariance of the estimate ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "05f6e13c-eb2e-49b9-b7d4-f01f499237e6"],
 " is ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"(", 
     FractionBox[
      RowBox[{"n", "-", "1"}], 
      RowBox[{"n", "-", "2"}]], ")"}], "*", 
    RowBox[{"Variance", "[", 
     RowBox[{"\[CapitalZeta]", "-", 
      RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}]}], "]"}], "*", 
    SuperscriptBox["\[CapitalLambda]", 
     RowBox[{"-", "1"}]]}], TraditionalForm]],ExpressionUUID->
  "ed6dc5b0-2569-4482-a89f-9e45c1d9c8e7"],
 " except for a small contribution from the a-priori covariance ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalLambda]", "0"], TraditionalForm]],ExpressionUUID->
  "117837c1-2354-4d76-b779-38f2077da583"],
 ". The correction factor ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    FractionBox[
     RowBox[{"n", "-", "1"}], 
     RowBox[{"n", "-", "2"}]], ")"}], TraditionalForm]],ExpressionUUID->
  "b55c017a-1015-4a56-951f-cf8b3a01de97"],
 " is a generalization \.7fof Bessel\[CloseCurlyQuote]s correction. The ",
 Cell[BoxData[
  FormBox["2", TraditionalForm]],ExpressionUUID->
  "b7c81e78-cd2f-451d-8792-9b212764ec84"],
 " in ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{"n", "-", "2"}], ")"}], TraditionalForm]],ExpressionUUID->
  "d9f330f5-17bd-4ad7-b656-bdd5eb0f57d5"],
 " in the denominator is due to the fact that we\[CloseCurlyQuote]re \
estimating two parameters from the data (see ",
 ButtonBox["VAN DE GEER, Least Squares Estimation, Volume 2, pp. \
1041\[Dash]1045, in Encyclopedia of Statistics in Behavioral Science, Eds. \
Brian S. Everitt & David C. Howell, Wiley, 2005",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["https://stat.ethz.ch/~geer/bsa199_o.pdf"], None},
  ButtonNote->"https://stat.ethz.ch/~geer/bsa199_o.pdf"],
 "). The denominator of the correction, in general, is ",
 Cell[BoxData[
  FormBox[
   RowBox[{"n", "-", "p"}], TraditionalForm]],ExpressionUUID->
  "5b344576-2589-491a-bed2-c362a3e367e3"],
 ", where ",
 Cell[BoxData[
  FormBox["n", TraditionalForm]],ExpressionUUID->
  "ab45ec8c-fdab-4d50-a890-e44870c87fa3"],
 " is the number of data and ",
 Cell[BoxData[
  FormBox["p", TraditionalForm]],ExpressionUUID->
  "606cb52c-426a-44c2-baf8-3756d84116c8"],
 " is the number of parameters being estimated."
}], "Text",
 CellChangeTimes->{{3.7274567852393503`*^9, 3.727456791351314*^9}, {
  3.7274626311713448`*^9, 3.727462680678966*^9}, {3.727472647355248*^9, 
  3.727472725986993*^9}, {3.7274728947945757`*^9, 3.727472940968391*^9}, {
  3.727474911778737*^9, 3.727474913439685*^9}, {3.727475723944086*^9, 
  3.727475733135212*^9}},ExpressionUUID->"523383eb-dc36-4095-bf5d-\
8f9158afe40a"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{
   RowBox[{"Inverse", "[", 
    RowBox[{
     RowBox[{"partials", "\[Transpose]"}], ".", "partials"}], "]"}], "*", 
   FractionBox[
    RowBox[{"nData", "-", "1"}], 
    RowBox[{"nData", "-", "2"}]], "*", 
   RowBox[{"Variance", "[", 
    RowBox[{"data", "-", 
     RowBox[{"partials", ".", 
      RowBox[{"{", 
       RowBox[{"mBar", ",", "bBar"}], "}"}]}]}], "]"}]}], "//", 
  "MatrixForm"}]], "Input",
 CellChangeTimes->{{3.7274431897876062`*^9, 3.7274432610082397`*^9}, {
   3.7274547829132023`*^9, 3.7274548281175823`*^9}, {3.727454917043985*^9, 
   3.727454946560256*^9}, {3.727455103776779*^9, 3.727455133855278*^9}, {
   3.727455965944152*^9, 3.727455966694631*^9}, {3.7274560116101933`*^9, 
   3.727456093212741*^9}, 3.72745616117476*^9, {3.727456227849722*^9, 
   3.727456234387219*^9}, 
   3.727472952057025*^9},ExpressionUUID->"0331aa4d-6603-4386-8aef-\
499f699d3ccc"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"0.002313198302743741`", 
      RowBox[{"-", "0.0023131983027437414`"}]},
     {
      RowBox[{"-", "0.002313198302743741`"}], "0.005449738374260678`"}
    },
    GridBoxAlignment->{
     "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, 
      "RowsIndexed" -> {}},
    GridBoxSpacings->{"Columns" -> {
        Offset[0.27999999999999997`], {
         Offset[0.7]}, 
        Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
        Offset[0.2], {
         Offset[0.4]}, 
        Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
  Function[BoxForm`e$, 
   MatrixForm[BoxForm`e$]]]], "Output",
 CellChangeTimes->{{3.727454928111648*^9, 3.72745494746028*^9}, 
   3.727455079366056*^9, {3.727455124455585*^9, 3.72745513496389*^9}, {
   3.727455812047991*^9, 3.727455864570829*^9}, {3.7274559677572517`*^9, 
   3.727455974867505*^9}, {3.727456050499832*^9, 3.727456094070848*^9}, {
   3.7274561424870367`*^9, 3.7274561865735826`*^9}, 3.727456239429667*^9, 
   3.7274568270134773`*^9, 3.727457103698028*^9, 3.7274626013731823`*^9, 
   3.727472137981408*^9, 3.727472954371911*^9, 
   3.727485511269794*^9},ExpressionUUID->"ba621fe2-584e-4094-b3b5-\
d9e848f5ad25"]
}, Open  ]],

Cell["\<\
Except for the reversed order, this is the same covariance matrix that \
Wolfram reports:\
\>", "Text",
 CellChangeTimes->{{3.727454999214408*^9, 3.7274550230616837`*^9}, {
  3.7274550552077837`*^9, 3.727455069630582*^9}, {3.727456815268976*^9, 
  3.72745682043734*^9}, {3.727462715836411*^9, 
  3.7274627328032312`*^9}},ExpressionUUID->"8ed415b2-9234-433b-9805-\
c4f5b3d21c3c"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"Reverse", "@", 
   RowBox[{"(", 
    RowBox[{"Reverse", "/@", 
     RowBox[{
      StyleBox["model",
       Background->RGBColor[1, 1, 0]], "[", "\"\<CovarianceMatrix\>\"", 
      "]"}]}], ")"}]}], "//", "MatrixForm"}]], "Input",
 CellChangeTimes->{{3.7274549491384163`*^9, 3.727454976961426*^9}, {
  3.727455029510784*^9, 
  3.727455047125711*^9}},ExpressionUUID->"dfa79ab6-ada2-4e31-abc3-\
0e79d8078441"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"0.00231319830274374`", 
      RowBox[{"-", "0.00231319830274374`"}]},
     {
      RowBox[{"-", "0.00231319830274374`"}], "0.005449738374260675`"}
    },
    GridBoxAlignment->{
     "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, 
      "RowsIndexed" -> {}},
    GridBoxSpacings->{"Columns" -> {
        Offset[0.27999999999999997`], {
         Offset[0.7]}, 
        Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
        Offset[0.2], {
         Offset[0.4]}, 
        Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
  Function[BoxForm`e$, 
   MatrixForm[BoxForm`e$]]]], "Output",
 CellChangeTimes->{{3.727454966848208*^9, 3.727454977604638*^9}, 
   3.727455048234387*^9, 3.7274550794174843`*^9, {3.727455816251672*^9, 
   3.727455842245935*^9}, 3.727455974915807*^9, {3.72745614253647*^9, 
   3.727456186624792*^9}, 3.727456827063628*^9, 3.727457103748019*^9, 
   3.727462601420088*^9, 3.727472138034376*^9, 
   3.727485511317802*^9},ExpressionUUID->"e93335d2-4879-4298-9075-\
08dab3575d35"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Don\[CloseCurlyQuote]t Invert That Matrix\.7f", "Subchapter",
 CellChangeTimes->{{3.727456856590333*^9, 3.727456866525626*^9}, {
  3.727456903416147*^9, 
  3.727456929038941*^9}},ExpressionUUID->"c36f1b05-7360-42d8-b27c-\
ef715e2b15f2"],

Cell["\<\
See https://www.johndcook.com/blog/2010/01/19/dont-invert-that-matrix/ \
\>", "Text",
 CellChangeTimes->{{3.727377065079856*^9, 3.7273770966536922`*^9}, {
  3.727456910929248*^9, 
  3.727456922321958*^9}},ExpressionUUID->"e81ff9ea-240a-4351-a21b-\
1659a0ba41a7"],

Cell[TextData[{
 "Replace ",
 Cell[BoxData[
  FormBox["Inverse", TraditionalForm]], "Code",ExpressionUUID->
  "4abf8fa5-41d8-4f44-9aa6-c9a86bf4cb42"],
 " with ",
 Cell[BoxData[
  FormBox["LinearSolve", TraditionalForm]], "Code",ExpressionUUID->
  "8ff097a2-4c9d-4e32-b0f6-892a5dda6fe0"],
 ":"
}], "Text",
 CellChangeTimes->{{3.727377065079856*^9, 3.7273770966536922`*^9}, {
   3.727456910929248*^9, 3.727456916094405*^9}, 
   3.727457033259179*^9},ExpressionUUID->"25324cb8-c04b-455b-b4e8-\
3078ec4aebdf"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "update", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"update", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"\[Psi]_", ",", "\[CapitalLambda]_"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"\[Zeta]_", ",", "a_"}], "}"}]}], "]"}], ":=", 
   "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"\[CapitalPi]", "=", 
       RowBox[{"(", 
        RowBox[{"\[CapitalLambda]", "+", 
         RowBox[{
          RowBox[{"a", "\[Transpose]"}], ".", "a"}]}], ")"}]}], "}"}], ",", 
     "\[IndentingNewLine]", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"LinearSolve", "[", 
        RowBox[{"\[CapitalPi]", ",", 
         RowBox[{"(", 
          RowBox[{
           RowBox[{
            RowBox[{"a", "\[Transpose]"}], ".", "\[Zeta]"}], "+", 
           RowBox[{"\[CapitalLambda]", ".", "\[Psi]"}]}], ")"}]}], "]"}], ",",
        "\[CapitalPi]"}], "}"}]}], "]"}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"MatrixForm", "/@", 
  RowBox[{"(", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"(", GridBox[{
         {"mBar"},
         {"bBar"}
        }], ")"}], ",", "\[CapitalPi]"}], "}"}], "=", 
    RowBox[{"Fold", "[", 
     RowBox[{"update", ",", "\[IndentingNewLine]", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"(", GridBox[{
           {"0"},
           {"0"}
          }], ")"}], ",", 
        RowBox[{"(", GridBox[{
           {"1.0*^-6", "0"},
           {"0", "1.0*^-6"}
          }], ")"}]}], "}"}], ",", "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"List", "/@", "data"}], ",", 
         RowBox[{"List", "/@", "partials"}]}], "}"}], "\[Transpose]"}]}], 
     "]"}]}], ")"}]}]}], "Input",
 CellChangeTimes->{{3.727054852495049*^9, 3.72705494257406*^9}, {
   3.727055026792467*^9, 3.727055093506559*^9}, {3.7270551930291023`*^9, 
   3.727055263833913*^9}, {3.727055297216107*^9, 3.7270554270906563`*^9}, {
   3.7270560338846903`*^9, 3.72705612788085*^9}, {3.7270561855129213`*^9, 
   3.7270561959544077`*^9}, {3.727056250031129*^9, 3.727056367103942*^9}, {
   3.727056427865035*^9, 3.727056443080068*^9}, {3.727056561323501*^9, 
   3.727056598046468*^9}, {3.727056640141169*^9, 3.727056654582451*^9}, {
   3.727056728700244*^9, 3.7270567914565277`*^9}, {3.727056869366274*^9, 
   3.727056921039433*^9}, 3.72705709924362*^9, {3.727057420502048*^9, 
   3.7270575464285316`*^9}, {3.7270577446377487`*^9, 3.727057775909028*^9}, {
   3.7270578799866133`*^9, 3.727057901007744*^9}, 3.7270581603330593`*^9, {
   3.727058349930079*^9, 3.7270584478842707`*^9}, {3.727058490337566*^9, 
   3.727058577824399*^9}, {3.727058673744141*^9, 3.7270586947547493`*^9}, {
   3.727058788099071*^9, 3.7270588909590683`*^9}, {3.727058934322414*^9, 
   3.7270589393580847`*^9}, {3.72705898616982*^9, 3.7270589868650723`*^9}, {
   3.7270592331231947`*^9, 3.727059237300102*^9}, {3.727370367915408*^9, 
   3.727370398721291*^9}, {3.727457046333558*^9, 3.727457067436592*^9}, {
   3.727473022344759*^9, 3.727473052764071*^9}, {3.727473241324421*^9, 
   3.7274732753376427`*^9}, {3.7274734820130367`*^9, 
   3.727473491340034*^9}},ExpressionUUID->"66a2bc5e-2305-4b13-bf00-\
ba929b97e656"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.6141132708583079`"},
       {
        RowBox[{"-", "0.39277532527470155`"}]}
      },
      GridBoxAlignment->{
       "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, 
        "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
      GridBoxSpacings->{"Columns" -> {
          Offset[0.27999999999999997`], {
           Offset[0.7]}, 
          Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
          Offset[0.2], {
           Offset[0.4]}, 
          Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
    Function[BoxForm`e$, 
     MatrixForm[BoxForm`e$]]], ",", 
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"280.35593320338984`", "119.`"},
       {"119.`", "119.000001`"}
      },
      GridBoxAlignment->{
       "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, 
        "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
      GridBoxSpacings->{"Columns" -> {
          Offset[0.27999999999999997`], {
           Offset[0.7]}, 
          Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
          Offset[0.2], {
           Offset[0.4]}, 
          Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
    Function[BoxForm`e$, 
     MatrixForm[BoxForm`e$]]]}], "}"}]], "Output",
 CellChangeTimes->{{3.727473265842018*^9, 3.7274732757004232`*^9}, 
   3.727473492609377*^9, 
   3.727485511701943*^9},ExpressionUUID->"24abbb7b-6c79-4eff-8ed5-\
a72a8f373cfb"]
}, Open  ]],

Cell["exactly as before.", "Text",
 CellChangeTimes->{{3.727473280120357*^9, 
  3.7274732832085*^9}},ExpressionUUID->"237bc93a-6488-4473-ac04-d70379aa3f72"],

Cell["\<\
We have eliminated memory bloat by accumulating estimate updates one \
observation at a time, with its paired partial. We reduce computation time \
and numerical risk by solving a linear system instead of inverting a matrix.\
\>", "Text",
 CellChangeTimes->{{3.727475777156247*^9, 
  3.727475832537896*^9}},ExpressionUUID->"0ec477c3-99cd-4442-a878-\
416d01f44e9a"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["The Dual Problem", "Chapter",
 CellChangeTimes->{{3.7273771343297157`*^9, 
  3.727377139800111*^9}},ExpressionUUID->"d121e86f-606e-4506-b961-\
51bd9832cdc7"],

Cell[TextData[{
 "When the model is a co-vector (row-vector), e.g., a gradient, we have the \
dual (transposed) problem. In that case, the observations ",
 Cell[BoxData[
  FormBox["\[CapitalOmega]", TraditionalForm]],ExpressionUUID->
  "0fcd49da-549d-4513-bc2a-55e5a3acca81"],
 " and the model ",
 Cell[BoxData[
  FormBox["\[CapitalGamma]", TraditionalForm]],ExpressionUUID->
  "c54ce737-c37c-4bf4-9780-c31893284bab"],
 " are now\.7f co-vectors with elements \[Omega] and \[Gamma]  instead of \
\[Zeta] and \[Psi]. The co-partials ",
 Cell[BoxData[
  FormBox["\[CapitalTheta]", TraditionalForm]],ExpressionUUID->
  "595110e6-8484-4e8f-924b-1631a75a7403"],
 " (replacing ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "a5959bab-c708-499c-8174-f99a22842500"],
 ") are now a co-vector of vectors \[Theta]. The observation equation looks \
like ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalOmega]", "=", 
    RowBox[{"\[CapitalGamma]", "\[CenterDot]", "\[CapitalTheta]"}]}], 
   TraditionalForm]],ExpressionUUID->"1de13883-b79d-4fc7-96bd-cf06cf9564dc"],
 " and the error-so-far like ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"(", 
     RowBox[{"x", "-", "\[Gamma]"}], ")"}], "\[CenterDot]", 
    "\[CapitalLambda]", "\[CenterDot]", 
    RowBox[{
     RowBox[{"(", 
      RowBox[{"x", "-", "\[Gamma]"}], ")"}], "\[Transpose]"}]}], 
   TraditionalForm]],ExpressionUUID->"b1dadb23-5a5d-431a-a7d4-4fd905f473fa"],
 ", where ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalLambda]", "=", 
    RowBox[{
     SubscriptBox["\[CapitalTheta]", 
      RowBox[{"so", "-", "far"}]], "\[CenterDot]", 
     RowBox[{
      SubscriptBox["\[CapitalTheta]", 
       RowBox[{"so", "-", "far"}]], "\[Transpose]"}]}]}], TraditionalForm]],
  ExpressionUUID->"3e9237e0-1492-41e0-9db9-9439ab6ebd6b"],
 ". We don\[CloseCurlyQuote]t change the name of \[CapitalLambda] because it\
\[CloseCurlyQuote]s symmetric. Adding a new observation ",
 Cell[BoxData[
  FormBox["\[Omega]", TraditionalForm]],ExpressionUUID->
  "26a398ad-1d0d-4db9-818d-7de4a635932a"],
 " introduces new error ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"(", 
     RowBox[{"\[Omega]", "-", 
      RowBox[{"x", "\[CenterDot]", "\[Theta]"}]}], ")"}], "\[CenterDot]", 
    RowBox[{
     RowBox[{"(", 
      RowBox[{"\[Omega]", "-", 
       RowBox[{"x", "\[CenterDot]", "\[Theta]"}]}], ")"}], "\[Transpose]"}]}],
    TraditionalForm]],ExpressionUUID->
  "032998b6-a96c-4d29-a61c-9ced58867980"],
 ". Minimizing the total error yields"
}], "Text",
 CellChangeTimes->{{3.727371218106142*^9, 3.727371240353272*^9}, {
   3.727371321069407*^9, 3.7273713296417093`*^9}, {3.7273713611621637`*^9, 
   3.7273714263190937`*^9}, {3.727371840069378*^9, 3.727371867019196*^9}, {
   3.727372044036509*^9, 3.727372359143402*^9}, {3.7273723988812304`*^9, 
   3.727372407831134*^9}, {3.727372456820087*^9, 3.727372576254916*^9}, {
   3.727372611880259*^9, 3.727372641828212*^9}, {3.727372745304285*^9, 
   3.727372762735136*^9}, {3.727373158078546*^9, 3.727373237360611*^9}, {
   3.727373343633808*^9, 3.727373660775297*^9}, {3.727373697002878*^9, 
   3.727373742098151*^9}, {3.7273741179275093`*^9, 3.727374119292781*^9}, 
   3.727374177681995*^9, {3.727374220080714*^9, 3.727374222719513*^9}, {
   3.7273750571767797`*^9, 3.7273750585288754`*^9}, {3.7273752241900177`*^9, 
   3.727375304998845*^9}, {3.727375354434124*^9, 3.727375583810218*^9}, {
   3.727375623795074*^9, 3.727375730528801*^9}, {3.727375806827318*^9, 
   3.727375932949609*^9}, {3.727376001504113*^9, 3.7273760221258574`*^9}, {
   3.727376063086153*^9, 3.727376156532493*^9}, {3.727376198118507*^9, 
   3.7273762919936867`*^9}, {3.727376351159185*^9, 3.727376363855044*^9}, {
   3.727376403668652*^9, 3.727376583289638*^9}, {3.727381968753878*^9, 
   3.7273821258780212`*^9}, {3.727382164112809*^9, 3.7273822084773273`*^9}, {
   3.727382248170485*^9, 3.7273823090681543`*^9}, {3.727382364895949*^9, 
   3.7273824245463467`*^9}, {3.727382516398245*^9, 3.727382517532123*^9}, {
   3.727382625583332*^9, 3.727382645314341*^9}, {3.727385201688477*^9, 
   3.72738520738167*^9}, {3.727385254691243*^9, 3.727385293535783*^9}, {
   3.727385323848435*^9, 3.727385374988439*^9}, {3.7273854084548693`*^9, 
   3.727385428127161*^9}, {3.727385559242544*^9, 3.72738569411847*^9}, {
   3.72738573051742*^9, 3.727385964398753*^9}, {3.727386005984235*^9, 
   3.72738615274949*^9}, {3.7273861954556293`*^9, 3.727386233565445*^9}, {
   3.727386269771594*^9, 3.727386271096093*^9}, {3.72738631202649*^9, 
   3.727386328269546*^9}, {3.727386360536889*^9, 3.7273864416740427`*^9}, {
   3.727386563853504*^9, 3.7273865694578733`*^9}, {3.727473691712545*^9, 
   3.727473706980104*^9}, {3.727473910423223*^9, 3.727473930847046*^9}, {
   3.7274739978523407`*^9, 3.727474003956037*^9}, {3.727475018387333*^9, 
   3.7274752353192043`*^9}, {3.7274758667159777`*^9, 
   3.7274761487187138`*^9}, {3.727485043325775*^9, 
   3.727485063734617*^9}},ExpressionUUID->"d67faade-c132-41c3-9dc7-\
43c866f7665d"],

Cell[BoxData[{
 FormBox[
  RowBox[{"\[Gamma]", "\[LeftArrow]", 
   RowBox[{
    RowBox[{"(", 
     RowBox[{
      RowBox[{"\[Gamma]", "\[CenterDot]", "\[CapitalLambda]"}], "+", 
      RowBox[{"\[Omega]", "\[CenterDot]", 
       RowBox[{"\[Theta]", "\[Transpose]"}]}]}], ")"}], ".", 
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{"\[CapitalLambda]", "+", 
       RowBox[{"\[Theta]", "\[CenterDot]", 
        RowBox[{"\[Theta]", "\[Transpose]"}]}]}], ")"}], 
     RowBox[{"-", "1"}]]}]}], TraditionalForm], "\n", 
 FormBox[
  RowBox[{"\[CapitalLambda]", "\[LeftArrow]", 
   RowBox[{"(", 
    RowBox[{"\[CapitalLambda]", "+", 
     RowBox[{"\[Theta]", "\[CenterDot]", 
      RowBox[{"\[Theta]", "\[Transpose]"}]}]}], ")"}]}], 
  TraditionalForm]}], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.727473769463854*^9, 3.7274737789509773`*^9}, {
  3.727473829318837*^9, 3.727473867909276*^9}, {3.727476024957868*^9, 
  3.727476030734923*^9}, {3.727476186696595*^9, 3.727476277887042*^9}, {
  3.727476413804344*^9, 
  3.727476415307171*^9}},ExpressionUUID->"ec0d2718-effc-45b0-9d6c-\
8e2b053b3ae7"],

Cell[TextData[{
 Cell[BoxData[
  FormBox["LinearSolve", TraditionalForm]], "Code",ExpressionUUID->
  "cb78cef6-6105-441c-b121-2693c4ccb84d"],
 " operates on the transposed right-hand side of the recurrence, and we \
transpose the solution to get the recurrence."
}], "Text",
 CellChangeTimes->{{3.727476457185042*^9, 3.727476506319212*^9}, {
  3.727476549477606*^9, 
  3.7274765535653963`*^9}},ExpressionUUID->"f9d0133f-10ac-42a8-892f-\
e1dd46fc9de7"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Transpose", "/@", 
  RowBox[{"List", "/@", 
   RowBox[{"partials", "\[LeftDoubleBracket]", 
    RowBox[{"1", ";;", "3"}], "\[RightDoubleBracket]"}]}]}]], "Input",
 CellChangeTimes->{{3.72747707307362*^9, 
  3.727477115704844*^9}},ExpressionUUID->"147aad0e-6381-4813-8249-\
cb0071926fea"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"-", "1.`"}], "}"}], ",", 
     RowBox[{"{", "1.`", "}"}]}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"-", "0.9661016949152542`"}], "}"}], ",", 
     RowBox[{"{", "1.`", "}"}]}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"-", "0.9322033898305084`"}], "}"}], ",", 
     RowBox[{"{", "1.`", "}"}]}], "}"}]}], "}"}]], "Output",
 CellChangeTimes->{{3.727477084780794*^9, 3.727477117039559*^9}, 
   3.7274855118872547`*^9},ExpressionUUID->"836f812b-ac12-4da4-9ec5-\
9ad2c0275ee0"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "coUpdate", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"coUpdate", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"\[Gamma]_", ",", "\[CapitalLambda]_"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"\[Omega]_", ",", "\[Theta]_"}], "}"}]}], "]"}], ":=", 
   "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"\[CapitalPi]", "=", 
       RowBox[{"(", 
        RowBox[{"\[CapitalLambda]", "+", 
         RowBox[{"\[Theta]", ".", 
          RowBox[{"\[Theta]", "\[Transpose]"}]}]}], ")"}]}], "}"}], ",", 
     "\[IndentingNewLine]", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{
        RowBox[{"LinearSolve", "[", 
         RowBox[{"\[CapitalPi]", ",", 
          RowBox[{
           RowBox[{"\[CapitalLambda]", ".", 
            RowBox[{"\[Gamma]", "\[Transpose]"}]}], "+", 
           RowBox[{"\[Theta]", ".", 
            RowBox[{"\[Omega]", "\[Transpose]"}]}]}]}], "]"}], 
        "\[Transpose]"}], ",", "\[CapitalPi]"}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"MatrixForm", "/@", 
  RowBox[{"Fold", "[", "\[IndentingNewLine]", 
   RowBox[{"coUpdate", ",", "\[IndentingNewLine]", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"(", GridBox[{
         {"0", "0"}
        }], ")"}], ",", 
      RowBox[{"(", GridBox[{
         {"1.0*^-6", "0"},
         {"0", "1.0*^-6"}
        }], ")"}]}], "}"}], ",", "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"List", "/@", 
        RowBox[{"List", "/@", "data"}]}], ",", 
       RowBox[{"Transpose", "/@", 
        RowBox[{"List", "/@", "partials"}]}]}], "}"}], "\[Transpose]"}]}], 
   "]"}]}]}], "Input",
 CellChangeTimes->{{3.727373282942794*^9, 3.727373311804191*^9}, {
   3.727376180517476*^9, 3.727376181653618*^9}, {3.7273767470214643`*^9, 
   3.727376772415944*^9}, {3.727376838568122*^9, 3.727376996930687*^9}, {
   3.72738256636836*^9, 3.727382569358986*^9}, {3.727382665863063*^9, 
   3.727382700900879*^9}, {3.7273827517208357`*^9, 3.7273827939392014`*^9}, {
   3.727382854392722*^9, 3.727382887313746*^9}, {3.727382928030025*^9, 
   3.7273829350883923`*^9}, {3.727383062267906*^9, 3.7273833443529673`*^9}, {
   3.727383375173339*^9, 3.727383375684123*^9}, {3.727383409608202*^9, 
   3.727383500022263*^9}, {3.727476338632511*^9, 3.7274763769100018`*^9}, {
   3.727476597581078*^9, 3.7274770426433783`*^9}, {3.727477148842947*^9, 
   3.727477169094758*^9}, 3.7274773761933823`*^9, {3.727477430990588*^9, 
   3.7274774638671503`*^9}, {3.7274774973342*^9, 
   3.7274775628692408`*^9}},ExpressionUUID->"e9da267b-be17-4802-a177-\
c1497c4dd5f4"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.6141132708583079`", 
        RowBox[{"-", "0.39277532527470155`"}]}
      },
      GridBoxAlignment->{
       "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, 
        "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
      GridBoxSpacings->{"Columns" -> {
          Offset[0.27999999999999997`], {
           Offset[0.7]}, 
          Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
          Offset[0.2], {
           Offset[0.4]}, 
          Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
    Function[BoxForm`e$, 
     MatrixForm[BoxForm`e$]]], ",", 
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"280.35593320338984`", "119.`"},
       {"119.`", "119.000001`"}
      },
      GridBoxAlignment->{
       "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, 
        "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
      GridBoxSpacings->{"Columns" -> {
          Offset[0.27999999999999997`], {
           Offset[0.7]}, 
          Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
          Offset[0.2], {
           Offset[0.4]}, 
          Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
    Function[BoxForm`e$, 
     MatrixForm[BoxForm`e$]]]}], "}"}]], "Output",
 CellChangeTimes->{
  3.727383072193253*^9, 3.727383354047873*^9, 3.727383390761856*^9, 
   3.7273834247745028`*^9, {3.727383458844083*^9, 3.7273835011111603`*^9}, 
   3.727442992945771*^9, 3.72744342284167*^9, 3.727443453425893*^9, 
   3.727444588221921*^9, 3.727444680887401*^9, 3.7274455727767982`*^9, 
   3.727446247275579*^9, 3.727446407013369*^9, 3.72744683899579*^9, {
   3.7274468858224363`*^9, 3.727447006380907*^9}, {3.727447047179235*^9, 
   3.72744708786588*^9}, 3.727447307524426*^9, 3.727447364795184*^9, 
   3.7274478393573503`*^9, 3.727449904650557*^9, 3.72745018058704*^9, 
   3.7274550798510838`*^9, 3.727455975376423*^9, {3.727456143282322*^9, 
   3.7274561870786343`*^9}, 3.727457104301549*^9, 3.7274626019151583`*^9, 
   3.727472138649213*^9, {3.727476713990739*^9, 3.727476741082378*^9}, 
   3.727476781425972*^9, {3.727476852153051*^9, 3.727476875672526*^9}, 
   3.727477048974312*^9, {3.727477150418499*^9, 3.727477170510271*^9}, 
   3.7274773773967867`*^9, 3.727477433395472*^9, {3.727477479732809*^9, 
   3.7274775639291077`*^9}, 
   3.727485511931388*^9},ExpressionUUID->"8328cacd-1a27-42d7-ba3a-\
3a1bf2fcd8bc"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Application of the Dual Problem", "Subchapter",
 CellChangeTimes->{{3.7274775822773733`*^9, 
  3.727477598570956*^9}},ExpressionUUID->"67da0275-7362-4383-be4f-\
6cb1c2ab0c5c"],

Cell[TextData[{
 "Imagine a scalar function ",
 Cell[BoxData[
  FormBox[
   RowBox[{"J", "(", "\[Theta]", ")"}], TraditionalForm]],ExpressionUUID->
  "a46cd651-f70b-4e54-9a6e-79b25be38dd7"],
 " of a column ",
 Cell[BoxData[
  FormBox["K", TraditionalForm]],ExpressionUUID->
  "ab77f425-87e5-438e-a999-1aa211a17e08"],
 "-vector ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Theta]", 
    RowBox[{"K", "\[Times]", "1"}]], TraditionalForm]],ExpressionUUID->
  "530b2f34-3906-48d5-af1a-6fe88ef3be97"],
 ". We want to estimate its gradient co-vector ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Del]", "J"}], TraditionalForm]],ExpressionUUID->
  "1baa8577-d9b7-4297-b4ca-ceff99f13c83"],
 ", given a batch of ",
 Cell[BoxData[
  FormBox["\[ScriptCapitalI]", TraditionalForm]],ExpressionUUID->
  "16c4d51a-b042-4c78-b089-d3f26f019b67"],
 " random increments ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[CapitalDelta]\[CapitalTheta]", 
     RowBox[{"K", "\[Times]", "\[ScriptCapitalI]"}]], ","}], 
   TraditionalForm]],ExpressionUUID->"07503476-cdb0-4917-b1e9-2a5bbc9dd003"],
 " from the system ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     RowBox[{"\[Del]", "J"}], "\[CenterDot]", 
     "\[CapitalDelta]\[CapitalTheta]"}], "=", 
    RowBox[{"\[CapitalDelta]", "\[ThinSpace]", "J"}]}], TraditionalForm]],
  ExpressionUUID->"7b50038e-f020-411d-a8a2-3c512776b63e"],
 ". Here, ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Del]", "J"}], TraditionalForm]],ExpressionUUID->
  "9f1abe83-d0e2-43da-a239-0e56844ff5d8"],
 " takes the role of the model whose state parameters ",
 Cell[BoxData[
  FormBox["\[CapitalGamma]", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "13159cff-0fd5-42f2-88dd-3dfe54451576"],
 " we want to estimate, ",
 Cell[BoxData[
  FormBox["\[CapitalDelta]\[CapitalTheta]", TraditionalForm]],ExpressionUUID->
  "e8af39e2-8f2f-44b9-9891-43d8fb9a20fe"],
 " takes the role of the partials of the model w.r.t. those parameters, and \
",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalDelta]", "\[ThinSpace]", "J"}], TraditionalForm]],
  ExpressionUUID->"7283a09d-4a9c-4d7a-bf28-7284694732f9"],
 " takes the role of measured data. Let ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalDelta]", "\[ThinSpace]", 
    SubscriptBox["J", 
     RowBox[{"\[ScriptCapitalI]", "\[Times]", "1"}]]}], TraditionalForm]],
  ExpressionUUID->"b150a273-134d-41de-89ec-a18131d86339"],
 " be a ",
 StyleBox["batch",
  FontSlant->"Italic"],
 " of observed increments to ",
 Cell[BoxData[
  FormBox["J", TraditionalForm]],ExpressionUUID->
  "cfe89e57-0ac0-495d-b341-1b42902614f8"],
 " and ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalDelta]\[CapitalTheta]", 
    RowBox[{"K", "\[Times]", "\[ScriptCapitalI]"}]], TraditionalForm]],
  ExpressionUUID->"a4dd2cda-aed9-4a18-8bbe-2a27aefc37f0"],
 " be a matrix of the ",
 Cell[BoxData[
  FormBox["\[ScriptCapitalI]", TraditionalForm]],ExpressionUUID->
  "cf54303a-6d4c-4789-96f9-78229c49e87c"],
 " corresponding column-vector random increments to the input vectors ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Theta]", 
    RowBox[{"K", "\[Times]", "1"}]], TraditionalForm]],ExpressionUUID->
  "63e9ca28-5dcc-463b-aaab-a5f0f7b650c8"],
 ". The right pseudoinverse ",
 Cell[BoxData[
  FormBox[
   RowBox[{"RPI", 
    OverscriptBox["=", "def"], 
    RowBox[{
     SuperscriptBox[
      RowBox[{"(", 
       RowBox[{
        SubscriptBox["\[CapitalDelta]\[CapitalTheta]", 
         RowBox[{"K", "\[Times]", "\[ScriptCapitalI]"}]], "\[CenterDot]", 
        SubsuperscriptBox["\[CapitalDelta]\[CapitalTheta]", 
         RowBox[{"K", "\[Times]", "\[ScriptCapitalI]"}], "\[Transpose]"]}], 
       ")"}], 
      RowBox[{"-", "1"}]], "\[CenterDot]", 
     SubsuperscriptBox["\[CapitalDelta]\[CapitalTheta]", 
      RowBox[{"K", "\[Times]", "\[ScriptCapitalI]"}], "\[Transpose]"]}]}], 
   TraditionalForm]],ExpressionUUID->"ba4a5a39-1a06-4e05-9e99-d9d1a27f325d"],
 " solves ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     RowBox[{"\[Del]", "\[ThinSpace]", 
      SubscriptBox["J", 
       RowBox[{"\[ScriptCapitalI]", "\[Times]", "1"}]]}], "\[CenterDot]", 
     SubscriptBox["\[CapitalDelta]\[CapitalTheta]", 
      RowBox[{"K", "\[Times]", "\[ScriptCapitalI]"}]]}], "=", 
    RowBox[{"\[CapitalDelta]", "\[ThinSpace]", 
     SubscriptBox["J", 
      RowBox[{"\[ScriptCapitalI]", "\[Times]", "1"}]]}]}], TraditionalForm]],
  ExpressionUUID->"c9d377eb-a6b1-41cd-9897-feb501018138"],
 " to yield ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"\[Del]", "\[ThinSpace]", 
     SubscriptBox["J", 
      RowBox[{"\[ScriptCapitalI]", "\[Times]", "1"}]]}], "\[TildeTilde]", 
    RowBox[{"\[CapitalDelta]", "\[ThinSpace]", 
     RowBox[{
      SubscriptBox["J", 
       RowBox[{"\[ScriptCapitalI]", "\[Times]", "1"}]], "\[CenterDot]", 
      "RPI"}]}]}], TraditionalForm]],ExpressionUUID->
  "ad9393d1-07c0-4272-a9d5-2784ac220021"],
 ". Use the co-update recurrence for this problem."
}], "Text",
 CellChangeTimes->{{3.727371218106142*^9, 3.727371240353272*^9}, {
   3.727371321069407*^9, 3.7273713296417093`*^9}, {3.7273713611621637`*^9, 
   3.7273714263190937`*^9}, {3.727371840069378*^9, 3.727371867019196*^9}, {
   3.727372044036509*^9, 3.727372359143402*^9}, {3.7273723988812304`*^9, 
   3.727372407831134*^9}, {3.727372456820087*^9, 3.727372576254916*^9}, {
   3.727372611880259*^9, 3.727372641828212*^9}, {3.727372745304285*^9, 
   3.727372762735136*^9}, {3.727373158078546*^9, 3.727373237360611*^9}, {
   3.727373343633808*^9, 3.727373660775297*^9}, {3.727373697002878*^9, 
   3.727373742098151*^9}, {3.7273741179275093`*^9, 3.727374119292781*^9}, 
   3.727374177681995*^9, {3.727374220080714*^9, 3.727374222719513*^9}, {
   3.7273750571767797`*^9, 3.7273750585288754`*^9}, {3.7273752241900177`*^9, 
   3.727375304998845*^9}, {3.727375354434124*^9, 3.727375583810218*^9}, {
   3.727375623795074*^9, 3.727375730528801*^9}, {3.727375806827318*^9, 
   3.727375932949609*^9}, {3.727376001504113*^9, 3.7273760221258574`*^9}, {
   3.727376063086153*^9, 3.727376156532493*^9}, {3.727376198118507*^9, 
   3.7273762919936867`*^9}, {3.727376351159185*^9, 3.727376363855044*^9}, {
   3.727376403668652*^9, 3.727376583289638*^9}, {3.727381968753878*^9, 
   3.7273821258780212`*^9}, {3.727382164112809*^9, 3.7273822084773273`*^9}, {
   3.727382248170485*^9, 3.7273823090681543`*^9}, {3.727382364895949*^9, 
   3.7273824245463467`*^9}, {3.727382516398245*^9, 3.727382517532123*^9}, {
   3.727382625583332*^9, 3.727382645314341*^9}, {3.727477798829159*^9, 
   3.727477804771535*^9}, 3.72748531820835*^9, {3.7274853820587463`*^9, 
   3.727485407991457*^9}, {3.727485470328353*^9, 
   3.72748548941591*^9}},ExpressionUUID->"c0c28ba5-2fc9-4b41-801e-\
0586ba0c01a4"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
},
WindowSize->{1095, 851},
WindowMargins->{{0, Automatic}, {Automatic, 0}},
PrintingCopies->1,
PrintingPageRange->{1, Automatic},
Magnification:>1.5 Inherited,
FrontEndVersion->"11.2 for Mac OS X x86 (32-bit, 64-bit Kernel) (September \
10, 2017)",
StyleDefinitions->FrontEnd`FileName[{$RootDirectory, "Users", "bbeckman"}, 
  "DefaultStyles.nb", CharacterEncoding -> "UTF-8"]
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1510, 35, 226, 4, 139, "Title",ExpressionUUID->"5ace0943-6b58-4f04-97b4-1ebcfe6e2f72"],
Cell[1739, 41, 177, 6, 103, "Text",ExpressionUUID->"6d6ece6d-9cb2-42e6-bc66-b8b248512ffd"],
Cell[CellGroupData[{
Cell[1941, 51, 165, 3, 101, "Chapter",ExpressionUUID->"9a47724a-7c15-45fa-9bd2-94f09f2bf165"],
Cell[2109, 56, 2518, 74, 164, "Text",ExpressionUUID->"4efc0572-ddca-4f28-a511-c10fdcfe3c1b"],
Cell[4630, 132, 1710, 49, 118, "DisplayFormulaNumbered",ExpressionUUID->"8f7e98ca-04c4-40c6-b775-389edb676598"],
Cell[6343, 183, 354, 7, 72, "Text",ExpressionUUID->"0baff407-b357-4fe5-9a53-b4a284986262"],
Cell[CellGroupData[{
Cell[6722, 194, 285, 5, 95, "Subchapter",ExpressionUUID->"d3769472-873f-41f6-8a75-5c85ce7936b2"],
Cell[7010, 201, 440, 8, 133, "Text",ExpressionUUID->"418f89a4-f1e1-428a-92a9-9965829ed9b2"],
Cell[7453, 211, 560, 17, 95, "Input",ExpressionUUID->"f8b5fb93-6981-45b8-a388-c64bd439dde2"]
}, Open  ]],
Cell[CellGroupData[{
Cell[8050, 233, 181, 3, 95, "Subchapter",ExpressionUUID->"93b95a60-1a08-4de3-9676-b562c9c7a989"],
Cell[8234, 238, 1071, 26, 164, "Text",ExpressionUUID->"3501115a-d07f-49d0-acc5-11ec346ea8f5"],
Cell[CellGroupData[{
Cell[9330, 268, 1891, 42, 188, "Input",ExpressionUUID->"0dad5213-f3bd-480b-b3f8-f477890b519d"],
Cell[11224, 312, 1849, 35, 80, "Output",ExpressionUUID->"5803b2b2-1e8d-4fd9-b3ec-e8823736b959"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[13122, 353, 180, 3, 95, "Subchapter",ExpressionUUID->"ed054fa9-c08b-44c6-8a7b-0dcd595df858"],
Cell[13305, 358, 1120, 28, 188, "Input",ExpressionUUID->"b44d5e34-efef-4f48-b9a7-719b68c57f20"],
Cell[CellGroupData[{
Cell[14450, 390, 1421, 29, 157, "Input",ExpressionUUID->"e60870b5-bbd0-44ff-99a1-884620c764b9"],
Cell[15874, 421, 1759, 30, 80, "Output",ExpressionUUID->"0dd31cc3-30d7-4f07-8af4-8551dd675cd4"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[17682, 457, 153, 3, 95, "Subchapter",ExpressionUUID->"eedd2e9d-e382-42b9-aaaf-e10da0f648f4"],
Cell[17838, 462, 519, 14, 72, "Text",ExpressionUUID->"49e9bcc9-2e31-4cd9-ba2c-0f6c4c682e44"],
Cell[CellGroupData[{
Cell[18382, 480, 874, 21, 126, "Input",ExpressionUUID->"73a4e9ea-ba7d-42cc-9186-54c9b0ede34c"],
Cell[19259, 503, 1356, 22, 63, "Output",ExpressionUUID->"d8de669a-0595-4445-ad42-fa3cbecc4d98"]
}, Open  ]],
Cell[20630, 528, 347, 7, 103, "Text",ExpressionUUID->"87bad75d-3ad7-4be9-a71a-e862138cfd62"],
Cell[20980, 537, 649, 15, 63, "Input",ExpressionUUID->"78fa6b39-5667-4a50-97f0-00c839dfef0d"],
Cell[CellGroupData[{
Cell[21654, 556, 927, 24, 95, "Input",ExpressionUUID->"217fe9a0-b8d1-4f7a-b5bd-e5ffee10a3ea"],
Cell[22584, 582, 8173, 151, 376, "Output",ExpressionUUID->"d45c6d61-c6fc-4a77-9dee-f54482d4f6ae"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[30806, 739, 312, 5, 95, "Subchapter",ExpressionUUID->"f63ffd1b-b86f-42d3-97fe-b86bf2765bc8"],
Cell[31121, 746, 1899, 48, 140, "Text",ExpressionUUID->"345dd050-8047-41f4-963a-a4ceb6821703"],
Cell[33023, 796, 755, 17, 38, "DisplayFormulaNumbered",ExpressionUUID->"d139a092-6246-44cb-9f29-ab5eb476d3cf"],
Cell[33781, 815, 209, 4, 72, "Text",ExpressionUUID->"0dc31811-95c1-4efd-a762-32d2cc8f4434"],
Cell[CellGroupData[{
Cell[34015, 823, 378, 9, 63, "Input",ExpressionUUID->"8a7bcee7-6af4-4af4-8eb7-cffbaf130094"],
Cell[34396, 834, 1157, 19, 63, "Output",ExpressionUUID->"48e8ef42-ca92-4c16-85a5-065038bfee26"]
}, Open  ]],
Cell[35568, 856, 607, 19, 72, "Text",ExpressionUUID->"9002b9aa-3e15-43a9-a7b4-b03717f1e09c"],
Cell[CellGroupData[{
Cell[36200, 879, 285, 8, 63, "Input",ExpressionUUID->"fdc259c6-bf44-4e06-9498-995f3df82972"],
Cell[36488, 889, 953, 16, 63, "Output",ExpressionUUID->"1656a4a6-a5c0-44dc-8c5b-2896007d1d97"]
}, Open  ]],
Cell[37456, 908, 860, 19, 133, "Text",ExpressionUUID->"66c60d03-b798-439e-9aa2-f6362b8564d0"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[38365, 933, 205, 4, 101, "Chapter",ExpressionUUID->"a3f5d0f2-9fe9-4c7f-8c3f-d141fcc2b151"],
Cell[38573, 939, 773, 19, 72, "Text",ExpressionUUID->"478b59b4-7382-40c1-baf5-5a8f8048af58"],
Cell[39349, 960, 1047, 27, 72, "DisplayFormulaNumbered",ExpressionUUID->"19ba13ba-a838-4929-be4d-043d72be3f34"],
Cell[40399, 989, 2119, 48, 72, "Text",ExpressionUUID->"3f4d84a0-fd27-47b3-b226-743e281da7e5"],
Cell[42521, 1039, 4128, 106, 225, "Text",ExpressionUUID->"53f1126b-e199-4222-9325-93c4e7bfc144"],
Cell[46652, 1147, 2693, 68, 135, "Text",ExpressionUUID->"b2e375f6-adc4-4d32-b5e5-8d4274e82eb3"],
Cell[CellGroupData[{
Cell[49370, 1219, 3568, 82, 347, "Input",ExpressionUUID->"1dd3c95c-36ff-4723-80bc-7414ec3492f4"],
Cell[52941, 1303, 1562, 41, 84, "Output",ExpressionUUID->"af9a9559-08b7-40aa-b836-40d7292d27e9"]
}, Open  ]],
Cell[54518, 1347, 730, 16, 108, "Text",ExpressionUUID->"8fcdd69f-b4e8-4721-9d73-12a24e8e0e37"],
Cell[55251, 1365, 438, 10, 154, "Text"],
Cell[55692, 1377, 1043, 27, 72, "Text",ExpressionUUID->"3bb9b24c-61c4-48e5-8583-e29da01c7bc2"],
Cell[CellGroupData[{
Cell[56760, 1408, 304, 7, 63, "Input",ExpressionUUID->"943cc4cd-72ef-4598-a22e-58c38092ac57"],
Cell[57067, 1417, 660, 14, 66, "Output",ExpressionUUID->"d7d56f77-073d-4ec6-a001-f8af4f456d06"]
}, Open  ]],
Cell[57742, 1434, 2764, 71, 265, "Text",ExpressionUUID->"523383eb-dc36-4095-bf5d-8f9158afe40a"],
Cell[CellGroupData[{
Cell[60531, 1509, 915, 22, 120, "Input",ExpressionUUID->"0331aa4d-6603-4386-8aef-499f699d3ccc"],
Cell[61449, 1533, 1275, 28, 101, "Output",ExpressionUUID->"ba621fe2-584e-4094-b3b5-d9e848f5ad25"]
}, Open  ]],
Cell[62739, 1564, 388, 8, 72, "Text",ExpressionUUID->"8ed415b2-9234-433b-9805-c4f5b3d21c3c"],
Cell[CellGroupData[{
Cell[63152, 1576, 441, 12, 63, "Input",ExpressionUUID->"dfa79ab6-ada2-4e31-abc3-0e79d8078441"],
Cell[63596, 1590, 1118, 26, 101, "Output",ExpressionUUID->"e93335d2-4879-4298-9075-08dab3575d35"]
}, Open  ]],
Cell[CellGroupData[{
Cell[64751, 1621, 242, 4, 95, "Subchapter",ExpressionUUID->"c36f1b05-7360-42d8-b27c-ef715e2b15f2"],
Cell[64996, 1627, 272, 6, 72, "Text",ExpressionUUID->"e81ff9ea-240a-4351-a21b-1659a0ba41a7"],
Cell[65271, 1635, 505, 14, 72, "Text",ExpressionUUID->"25324cb8-c04b-455b-b4e8-3078ec4aebdf"],
Cell[CellGroupData[{
Cell[65801, 1653, 3269, 78, 316, "Input",ExpressionUUID->"66a2bc5e-2305-4b13-bf00-ba929b97e656"],
Cell[69073, 1733, 1519, 41, 84, "Output",ExpressionUUID->"24abbb7b-6c79-4eff-8ed5-a72a8f373cfb"]
}, Open  ]],
Cell[70607, 1777, 156, 2, 72, "Text",ExpressionUUID->"237bc93a-6488-4473-ac04-d70379aa3f72"],
Cell[70766, 1781, 374, 7, 133, "Text",ExpressionUUID->"0ec477c3-99cd-4442-a878-416d01f44e9a"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[71189, 1794, 163, 3, 101, "Chapter",ExpressionUUID->"d121e86f-606e-4506-b961-51bd9832cdc7"],
Cell[71355, 1799, 5006, 102, 225, "Text",ExpressionUUID->"d67faade-c132-41c3-9dc7-43c866f7665d"],
Cell[76364, 1903, 1099, 27, 72, "DisplayFormulaNumbered",ExpressionUUID->"ec0d2718-effc-45b0-9d6c-8e2b053b3ae7"],
Cell[77466, 1932, 451, 10, 103, "Text",ExpressionUUID->"f9d0133f-10ac-42a8-892f-e1dd46fc9de7"],
Cell[CellGroupData[{
Cell[77942, 1946, 311, 7, 63, "Input",ExpressionUUID->"147aad0e-6381-4813-8249-cb0071926fea"],
Cell[78256, 1955, 647, 20, 63, "Output",ExpressionUUID->"836f812b-ac12-4da4-9ec5-9ad2c0275ee0"]
}, Open  ]],
Cell[CellGroupData[{
Cell[78940, 1980, 2690, 66, 326, "Input",ExpressionUUID->"e9da267b-be17-4802-a177-c1497c4dd5f4"],
Cell[81633, 2048, 2473, 54, 84, "Output",ExpressionUUID->"8328cacd-1a27-42d7-ba3a-3a1bf2fcd8bc"]
}, Open  ]],
Cell[CellGroupData[{
Cell[84143, 2107, 181, 3, 95, "Subchapter",ExpressionUUID->"67da0275-7362-4383-be4f-6cb1c2ab0c5c"],
Cell[84327, 2112, 6738, 162, 264, "Text",ExpressionUUID->"c0c28ba5-2fc9-4b41-801e-0586ba0c01a4"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature DwDR7Lf@jhInMDKtDfy1Ece0 *)
