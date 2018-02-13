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
NotebookDataLength[     98635,       2422]
NotebookOptionsPosition[     91530,       2301]
NotebookOutlinePosition[     92015,       2319]
CellTagsIndexPosition[     91972,       2316]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell["\.7fLinear Regression by Folding", "Title",
 CellChangeTimes->{{3.727038100871808*^9, 3.727038119380846*^9}, {
  3.727471593317396*^9, 
  3.7274715984595823`*^9}},ExpressionUUID->"0f858e27-6aa2-4959-ba50-\
014340204105"],

Cell["\<\
Brian Beckman
12 Feb 2018\
\>", "Text",
 CellChangeTimes->{{3.727471602355763*^9, 
  3.7274716101393967`*^9}},ExpressionUUID->"bfc46f02-95be-4ccf-a54b-\
5729a6a2d2f1"],

Cell[CellGroupData[{

Cell["Motivating Example", "Chapter",
 CellChangeTimes->{{3.727448922904108*^9, 
  3.7274489260707684`*^9}},ExpressionUUID->"ee617776-b99f-45f6-89dd-\
84ae49138941"],

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
  3.727471663001911*^9}},ExpressionUUID->"400b70f9-1594-48bd-ac23-\
cd631be7153c"],

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
  3.727471719286708*^9}},ExpressionUUID->"cff2b503-5678-48a0-9b30-\
a15bcb98c593"],

Cell["\<\
This extends to any linear system with any number of parameters\.7f and with \
tensors in the matrix slots. \
\>", "Text",
 CellChangeTimes->{{3.72743218344071*^9, 3.727432337884823*^9}, {
  3.727449535267564*^9, 3.727449543573064*^9}, {3.7274752783628683`*^9, 
  3.727475287576037*^9}},ExpressionUUID->"a8cd1342-0d92-4914-ae2e-\
c3bf22e1811e"],

Cell[CellGroupData[{

Cell["Ground Truth", "Subchapter",
 CellChangeTimes->{{3.727038130736038*^9, 3.727038133799975*^9}, {
   3.727038190200441*^9, 3.727038194262557*^9}, {3.7270382668439693`*^9, 
   3.727038273195747*^9}, 
   3.727449676637067*^9},ExpressionUUID->"439ef9a8-1611-4eb7-a71c-\
06c4f3290d82"],

Cell["\<\
Make some data by sampling a line specified by the following ground truth, \
then adding some noise. Run the faked data through our estimation procedures \
and see how close the estimates come to the ground truth.\
\>", "Text",
 CellChangeTimes->{{3.7274717486938457`*^9, 3.727471863121015*^9}, {
   3.727471943951993*^9, 3.727471974860942*^9}, 
   3.7274752992891693`*^9},ExpressionUUID->"26b28091-0971-49e7-af89-\
f3543e79ade6"],

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
  3.727450221204816*^9}},ExpressionUUID->"d499b6bb-b246-4513-ae9b-\
014ceeb54501"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Partials", "Subchapter",
 CellChangeTimes->{{3.727038381072097*^9, 3.7270383858220654`*^9}, 
   3.727472022244463*^9},ExpressionUUID->"b52bd5e9-51a4-4140-90af-\
c857568590d5"],

Cell[TextData[{
 "The partials ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "9309b19a-9472-465f-84be-8ecd35011dde"],
 " are a (column) vector of co-vectors (row vectors). Each co-vector is the \
gradient of the observation model, namely of ",
 Cell[BoxData[
  FormBox[
   RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}], TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "24f492e1-8cbc-4b9e-85e3-f2475b30584a"],
 ", with respect to ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "32a3d80d-1e15-455e-a684-128e0a220123"],
 ", evaluated at a specific ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "482810e6-322f-4783-a84c-dc625d8b0917"],
 ". Gradients of vector functions are co-vectors, that is, linear \
transformations of vectors. This fact becomes interesting when considering \
the dual problem, below."
}], "Text",
 CellChangeTimes->{{3.727474059032774*^9, 3.727474241042626*^9}, {
  3.727475321236279*^9, 
  3.727475337122877*^9}},ExpressionUUID->"7a014088-0fdb-4074-b068-\
3a3e19edf249"],

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
   3.727472063729579*^9}},ExpressionUUID->"a7b3e667-1dac-4247-9849-\
dc483276a9da"],

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
    RowBox[{"{", 
     RowBox[{
      RowBox[{"-", "0.9322033898305084`"}], ",", "1.`"}], "}"}], ",", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"-", "0.8983050847457628`"}], ",", "1.`"}], "}"}], ",", 
    RowBox[{"\[LeftSkeleton]", "112", "\[RightSkeleton]"}], ",", 
    RowBox[{"{", 
     RowBox[{"2.9322033898305087`", ",", "1.`"}], "}"}], ",", 
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
   3.727462600894341*^9, 3.7274720648603897`*^9, 
   3.727472137401977*^9},ExpressionUUID->"b52e1848-4c40-4623-b1c0-\
57dc1e988072"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Fake Data", "Subchapter",
 CellChangeTimes->{{3.727038130736038*^9, 3.727038133799975*^9}, 
   3.727038190200441*^9},ExpressionUUID->"1e9e9472-1ea4-47a7-9d39-\
116de0d05cf1"],

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
  3.727451399962222*^9}},ExpressionUUID->"17ca9237-a02b-4905-a0af-\
29a0dd6e2c31"],

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
  3.727472053265984*^9}},ExpressionUUID->"8ce05715-92b7-422c-9ceb-\
2e30074647f7"],

Cell[BoxData[
 TagBox[
  RowBox[{"{", 
   RowBox[{
    RowBox[{"-", "1.0611881454651633`"}], ",", "0.0515971240999461`", ",", 
    RowBox[{"-", "1.315158129559513`"}], ",", "0.162078869436872`", ",", 
    RowBox[{"\[LeftSkeleton]", "111", "\[RightSkeleton]"}], ",", 
    "1.503404337646891`", ",", "1.1797678499131568`", ",", 
    "1.76527141552486`", ",", "1.970624636532678`"}], "}"}],
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
   3.72747204808424*^9, 3.727472053925476*^9}, 
   3.727472137462739*^9},ExpressionUUID->"0c9cdd6e-7f80-4288-bf15-\
5819a6bf59fa"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Model", "Subchapter",
 CellChangeTimes->{{3.727039137746358*^9, 
  3.727039138418336*^9}},ExpressionUUID->"0ef2e2ec-845b-4518-b5d3-\
5898a4387d1f"],

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
  3.727472088160452*^9}},ExpressionUUID->"0ef3d696-1f75-4a00-99ef-\
9d0dd81af8b5"],

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
   3.727445246314415*^9},ExpressionUUID->"3ade0ac4-2d53-47a7-ab68-\
3b9323459560"],

Cell[BoxData[
 RowBox[{
  RowBox[{"-", "0.28379024006958437`"}], "+", 
  RowBox[{"0.49626175836674846`", " ", "\[Xi]"}]}]], "Output",
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
   3.727462600989726*^9, 
   3.7274721375146713`*^9},ExpressionUUID->"319b75a3-4760-4037-bd52-\
9821d0911ca5"]
}, Open  ]],

Cell["\<\
Un-comment the following line to see everything Wolfram has to say about this \
model (it\[CloseCurlyQuote]s a lot of data).\
\>", "Text",
 CellChangeTimes->{{3.727445705251766*^9, 3.727445735756525*^9}, {
   3.727446896680705*^9, 3.727446898174596*^9}, 
   3.727447110091947*^9},ExpressionUUID->"04f2e82a-193d-4277-bf02-\
0d1fec304720"],

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
  3.727454016578137*^9}},ExpressionUUID->"cbd42705-9e56-4775-91bc-\
8faa382e378f"],

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
   3.727472978941469*^9}},ExpressionUUID->"f6fa43c5-86da-458f-907b-\
a320e1c2a482"],

Cell[BoxData[
 GraphicsBox[{{{}, {{}, 
     {RGBColor[0.368417, 0.506779, 0.709798], PointSize[0.009166666666666668],
       AbsoluteThickness[1.6], PointBox[CompressedData["
1:eJw1VQtU02UUH2M8tMiUsCIE84WlBKj4KOl+dsREBZGQ1EBTXmJoHAEV8sHx
AbhEeQmKaGikgU/QGaLtSlORwOAIzgkCA6fANmQPmOPl2r7/fztnZ2fn+3/3
3t/r/j/d9HNgBJfD4ew0fk2/zEeF6rqKnwoHVXjssq2jv/w1Bmxy9VRtKQHn
H8bOKWjswQlb55MXo/vxiulYqMTkgEcfc/AeeN+ctHl+sQKrxG23Tu/UYG3Y
jP0p2XKcOaoqwdarEun1Pd2YtypkIEQ/iHLhQuONLtzRsG/7OA8tJsX41McG
diJ3Y13xYPZzpOUXvsJhQ7L4+mkZnqgK5tm5vsQr2wnf31+PrgkbjCPJ8L4k
MEPd34G0/VAHPrsYPTljHPfuEmO1Ny/bMSi0xc113hNo3JNo7CDF1GzXM0ur
1fjQVC6hDb/8tfZ6cLEUXpU6LBL5tmD/2tUP/tmsQ9PpBudmPBN7sLcntgFo
eY0E3SWfOUZcacBvjA/nVYmx5Gl/qkGmwh8ZgnDbtmGXA/wq3GtqF/sYPVq/
Kt/mVwEFzADoPi3/qgO3H+NN48+pxUvLihKDyuvhGm1fhTLH+ENuIiGoakwE
ijArbqT6cspTXEMHEmLZQIO9j4MEKbxSAWal+84oj7wHGRXuRslK8GTmQsez
SilyKEGZ6OR9lSzXyM3/YaBTo2lyacNC5nmIDnMmCe515nrA8dRVtqQkYwDT
D8ZfihNlHO02zwPdE/14u3e1IjsvLJmWElG5Woy7GDxQnXtx3Sj+YzNe0J3I
Th47tx13M3xAsuZGVm51PbB8QVqOVY1PUCcShk9Qy79Yd+rgY5jC8A26wZHF
LpobwOoBOZzSopit7SBj9AJvw/qHaSAx6wnH/q7NGzpSiazesOIdp46JVy8g
6we4Zu9RrvIVmP0Cz+5r3nXJqcbpjJ8gucw23N/tBbB+gxChXY2dj9TsR7Du
n1Wyw0EJrF8ha2quoFgtB9bPUGkg665ea8IQxu+QX81/wM95AWweQLr5eN3x
IDksZPICri2+h2cvlpjzBAp1gkB+tNGcNxD6WxRZelZCBpNHkBZu/Lx7ZRyw
eYU1F7ct+Db1LlK2+Cooe1KdNCGqF6icDmpQ3S9IijqciiWm40I1bFL4tHkZ
c9JR9NqoqAY89CsyPY0+ofBuaiBGFi6ysJUDvb5IC/UB3VyAP5Bf2G68oQXl
rPjQoMQeuGeSK7gPpuz8ZK1Vuw6GTeXb++D82/9+u3lGAXOoAfphXd8xZWBI
N1C63vTD21u9TaV+OqTt9+sgUhKhce1SQmueifA3sLLCcG6eswrGm9TNewPD
p3OT81/1Ah1vkh5S7FZkpsTWYkq2ycB6SNMLZnzHuwOU/vkD8NxbZ9fV2gp6
0/iiATh6+/ZocX4feNCFNgh5PlvO5Wh6gLHXIHCdmzftW94EFF7YEKTZj+vw
inqCEgp4COa+PqwYmquEcRTQMIg/aFBeO/UClpng80YgmLfD0JnaCPvpQCNw
x3lMXHqgEmi8HN/C0WerOiKjm4HSU/QWnKaqW/3SdDCTXjBAXyRXl6+phHCT
PSoMEK6wE4/MfMDi5RAL/gXvJBsF6y8O8QiQCYsL5MDg5xCpx91kARHAZAqI
Q2Ticu2eGiki5cOC8P89kPa7TgvM/rUgH209cmqntgeovCILsuH1eUGbVSPk
0IG5RH8nPDvc6xXLF5e47No9uWWLjPUvl9Tz7EOHWztZ/rgk5mRCXugSEbsv
LYnwiGJaU7MezlI+LUlwz4zAzpda9v1gSWIUaw+9ly7GZ5RfSxLS5T/q/qIB
oPGbwyOOBfsiYzs7gI6byCP7LSd9SOpHgMkHj0hn29YV33jE8m9FSEFU4rz3
r7D724rkCifsFbtxCKOHFfHjPxq5LFCxebIihbKxeYnZf+Ftqo81KZ2+/Zfy
DA75ngKwJk7ZCzTp9r2gpXpZk2rJn+PL4jXAvA+tyYrb0WOWrtcClcvdhjhX
9NxQ2+mB2T82pGtYRIKkGlZPG6LsCPNO/3qYzastSTvRXXY51QD/A+Sd1Os=

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
1:eJwB4QQe+yFib1JlAgAAAE0AAAACAAAAXH4s1P//778QBQ+GL/bov97yRxDz
9e+/AvY4wjLx6L9gZ2NM5uvvv/TmYv417Oi/ZVCaxMzX77/YyLZ2POLov24i
CLWZr++/oIxeZ0nO6L+BxuOVM1/vvzAUrkhjpui/pg6bV2e+7r9PI00Ll1bo
v/CeCdvOfO2/jUGLkP6257+qqRfUg8Pqv9RnfFr0XOa/PYDfKG446L86BLeZ
2Bnlv27XiAseuuW/Tj30ZhPd47/FGGPgswXjvy5gpvN0heK/9SX3EH9/4L8s
+aH1xEThv5c6eGdghtu/7PckbnfS379/KsXITSfWv9o2Cw0SKN2/GbKF4aUk
0b8IYoSWiavav/8bUL2Ta8e/zGDnnk75179fBvhMYo26v89L3ZHwdNW/rWZv
OSanmr8tcNigP/3Sv6wDcj0/1a0/IWi9LtxP0L9Iv//2robBP6iYak6roMu/
C1XfVXZwzD86CC49OTbGvyx0nL6Tk9M/g+r7YyHlwL8gptWagZLYP5ZK37+G
37e/yAOtkqP93T/4HNxmATyqv99kiGkthuE/4BpEinKfiL+0XYkXo0PkP7Dl
1lS4M58/69WoN1P05j/EEJ8LFnuyP0mCDvzNduk/ILe8V8pxvD+BREPOYi/s
P5SHGVSkn8M/4Dq+RMK57j8a2y6nqarIP1HYqxaum/A/5rs5wlSczT8fHuAR
iPXxP8V6uG+yfNE/AH43X0c48z9XK8GTXf3TP85odrMTlvQ/VQjgOLuz1j9O
k8RAfe31P/er+cFrXdk/4dc1IMwt9z9ZY4BgP9nbP2GnjgYoifg/JUcdgMWK
3j/0kAo/ac35P1qfk1o3h+A/ObqVsEcL+z9y/hVntcLhP2puCCkzZPw/wHMj
tAwZ4z+vPJ7zA6b9P+5y54t1WOQ/4ZUbxeEC/z9SiDakt7LlP5MEXnRSJABA
lic8Rwv25j8O3rWiAsQAQCoqP1wIM+g/AH2BVDlxAUD2Qs2x3orpP/uoXq/i
EgJAouURksbL6j9tmq+NEsICQISe4bKHJ+w/uCuICBFuA0C4uq5F8nztPwxK
ciyCDgRAymAyY2677j/XLdDTebwEQIqOoOBhCvA/q54/JOReBUCeMQNVlavw
P1ivNhEd/gVAXIZkgp1J8T97haGB3KoGQDRmC1AS9fE/qOgdmw5MB0D8ig3j
D5XyP4SdhWDeTgdAVKjURtqX8j9gUu0lrlEHQK3Fm6qkmvI/F7y8sE1XB0Bd
ACpyOaDyP4aPW8aMYgdAvXVGAWOr8j9kNpnxCnkHQH9gfx+2wfI/IIQUSAem
B0ACNvFbXO7yP/w4fA3XqAdAW1O4vybx8j/Y7ePSpqsHQLNwfyPx8/I/j1ez
XUaxB0Bjqw3rhfnyP/4qUnOFvAdAxCAqeq8E8z/c0Y+eA9MHQIULY5gCG/M/
uIb3Y9PVB0DeKCr8zB3zP5Q7Xymj2AdANkbxX5cg8z9LpS60Qt4HQOaAfycs
JvM/unjNyYHpB0BH9pu2VTHzP5YtNY9R7AdAnxNjGiA08z9x4pxUIe8HQPcw
Kn7qNvM/KExs38D0B0Cna7hFfzzzPwQB1KSQ9wdA/4h/qUk/8z/gtTtqYPoH
QFimRg0UQvM/vGqjLzD9B0Cwww1x3kTzP5cfC/X//wdACOHU1KhH8z862nS/

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
  PlotRange->{{-1., 3.}, {-2.259063984548885, 2.0706643718923137`}},
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
   3.727462557970257*^9, 3.727462601129395*^9, 
   3.727472137742113*^9},ExpressionUUID->"110cc4b0-bfa0-4932-8428-\
a35e4547e0c0"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Normal Equations ", "Subchapter",
 CellChangeTimes->{{3.727038154048767*^9, 3.7270381788082533`*^9}, {
  3.72737126177953*^9, 3.727371269395361*^9}, {3.7273713004742193`*^9, 
  3.727371301473422*^9}, {3.727432388690963*^9, 
  3.727432389111678*^9}},ExpressionUUID->"51a7bc1e-b7b8-43c8-9abf-\
cf6be427b759"],

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
   3.727472171381256*^9}},ExpressionUUID->"8b5a501a-19e0-431a-9a5e-\
07b5f12e6dc6"],

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
   3.727445003473629*^9},ExpressionUUID->"b2685cf4-e531-4006-a04f-\
1176adc74eef"],

Cell["That gives the same answer as Wolfram\[CloseCurlyQuote]s built-in:", \
"Text",
 CellChangeTimes->{{3.72747218573221*^9, 
  3.727472199188305*^9}},ExpressionUUID->"b67ab191-5f84-4595-aa41-\
9bc11cf8d5f3"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"Inverse", "[", 
   RowBox[{
    RowBox[{"partials", "\[Transpose]"}], ".", "partials"}], "]"}], ".", 
  RowBox[{"partials", "\[Transpose]"}], ".", "data"}]], "Input",
 CellChangeTimes->{{3.727039915051565*^9, 3.727039947873397*^9}, {
  3.7274446395823927`*^9, 
  3.727444668828559*^9}},ExpressionUUID->"693659ef-6e19-4c29-9130-\
8963286da21c"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.49626175836674846`", ",", 
   RowBox[{"-", "0.2837902400695844`"}]}], "}"}]], "Output",
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
   3.727457103498486*^9, 3.7274626011682777`*^9, 
   3.7274721377771683`*^9},ExpressionUUID->"3c79d10c-9da3-49ad-bb3e-\
4950d7e8d089"]
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
  3.727433150009388*^9}},ExpressionUUID->"51e339e6-b089-40aa-8980-\
efce3de6b1bd"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{
   StyleBox["PseudoInverse",
    Background->RGBColor[0.87, 0.94, 1]], "[", "partials", "]"}], ".", 
  "data"}]], "Input",
 CellChangeTimes->{{3.7273712853724957`*^9, 
  3.727371293874542*^9}},ExpressionUUID->"e35bf53b-c8ea-42ea-98db-\
1836a2b88fdf"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.4962617583667484`", ",", 
   RowBox[{"-", "0.2837902400695843`"}]}], "}"}]], "Output",
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
   3.727457103548245*^9, 3.7274626012243567`*^9, 
   3.727472137829957*^9},ExpressionUUID->"0e3eb4a9-f7b1-4e63-afb6-\
52e65014ab5f"]
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
   TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "d629675c-f1af-4371-900e-61ae690a0095"],
 " is a very nasty computation, in memory usage, in time, and in numerical \
risk. Eliminate these defects with a recurrence. This recurrence is \
mathematically identical to a Kalman filter in parameter-estimation mode, \
though we do not prove that here."
}], "Text",
 CellChangeTimes->{{3.727472215578988*^9, 3.727472331662753*^9}, {
  3.727472374436943*^9, 3.727472378052897*^9}, {3.727475400731699*^9, 
  3.727475478400813*^9}},ExpressionUUID->"ea8aa4be-9c5c-4b1b-bb48-\
2947585b26ff"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Recurrence", "Chapter",
 CellChangeTimes->{{3.7270402093685093`*^9, 3.727040216990353*^9}, {
  3.72744887906024*^9, 
  3.727448879173937*^9}},ExpressionUUID->"18ffab3e-2f16-4b28-bab9-\
c79d3fbbb6d6"],

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
  3.727475507311516*^9}},ExpressionUUID->"4b62ee72-d304-4670-bf4f-\
815c69daf0c5"],

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
  3.727443902554981*^9}},ExpressionUUID->"a6a743a0-cd50-41f5-acb6-\
d2bae2e6dbb2"],

Cell[TextData[{
 "where ",
 Cell[BoxData[
  FormBox["\[Psi]", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
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
   3.727475555533572*^9}},ExpressionUUID->"cfbf3ba5-f976-4b14-8254-\
984c44b6046d"],

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
   3.7274756335231857`*^9}},ExpressionUUID->"e646dc85-5149-4893-8b11-\
5d42f8e61f47"],

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
   3.727475668421556*^9}},ExpressionUUID->"dff38e8d-87b6-4201-8e23-\
8c819b678125"],

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
   3.727473470385874*^9}},ExpressionUUID->"d51673f1-85e2-4a7e-8c9f-\
e8d6e2bcd55d"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.4962617535329824`"},
       {
        RowBox[{"-", "0.2837902328514264`"}]}
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
   3.727472582072073*^9, 3.727472596728858*^9}, 
   3.72747347227721*^9},ExpressionUUID->"dea96303-7bb8-4a6e-9a65-\
c66dcd615aff"]
}, Open  ]],

Cell[TextData[{
 "The estimates ",
 Cell[BoxData[
  FormBox["mBar", TraditionalForm]], "Code",
  FormatType->"TraditionalForm",ExpressionUUID->
  "ace851a5-9f4d-49ce-a0fa-1ee094af68d5"],
 " and ",
 Cell[BoxData[
  FormBox["bBar", TraditionalForm]], "Code",
  FormatType->"TraditionalForm",ExpressionUUID->
  "1f76bfd3-e9db-47db-a0f3-738e5d40384b"],
 " are exactly what we got from Wolfram\[CloseCurlyQuote]s built-in."
}], "Text",
 CellChangeTimes->{{3.727455669635949*^9, 3.727455714844105*^9}, {
  3.727456293561727*^9, 3.727456338621636*^9}, {3.727456381984915*^9, 
  3.727456493199937*^9}, {3.7274567040936413`*^9, 3.727456704869124*^9}, {
  3.727456739701139*^9, 3.72745677855204*^9}, {3.727472821547103*^9, 
  3.727472872838442*^9}},ExpressionUUID->"ebb721f6-a49a-4eb7-a219-\
38c6279512cc"],

Cell[TextData[{
 "The mappings of ",
 Cell[BoxData[
  FormBox["List", TraditionalForm]], "Code",
  FormatType->"TraditionalForm",ExpressionUUID->
  "370d0a8b-9c99-495c-8b0f-e38240d3f06a"],
 " over the data and partials convert them into column vectors, as required \
by the recurrences in linear-algebra form."
}], "Text",
 CellChangeTimes->{{3.727473114735071*^9, 3.727473196429072*^9}, 
   3.727475691841303*^9},ExpressionUUID->"d6ebfc40-1325-46f2-8e54-\
1afec927e438"],

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
  3.72747570624365*^9}},ExpressionUUID->"19a8376c-990f-43f2-84a6-\
ad48f08b1aa9"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"\[CapitalPi]", "-", 
  RowBox[{
   RowBox[{"partials", "\[Transpose]"}], ".", "partials"}]}]], "Input",
 CellChangeTimes->{{3.7274551709419003`*^9, 3.727455208922634*^9}, {
  3.727455747486219*^9, 
  3.727455758602953*^9}},ExpressionUUID->"10c385cd-d54b-4bb2-b548-\
a50b2024fa75"],

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
   3.727457103648644*^9, 3.7274626013231*^9, 
   3.727472137933955*^9},ExpressionUUID->"9a40e403-635d-4e8b-b899-\
ca73675e41f6"]
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
   SubscriptBox["\[CapitalLambda]", "0"], TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
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
  FormBox["2", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "b7c81e78-cd2f-451d-8792-9b212764ec84"],
 " in ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{"n", "-", "2"}], ")"}], TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
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
   RowBox[{"n", "-", "p"}], TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "5b344576-2589-491a-bed2-c362a3e367e3"],
 ", where ",
 Cell[BoxData[
  FormBox["n", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "ab45ec8c-fdab-4d50-a890-e44870c87fa3"],
 " is the number of data and ",
 Cell[BoxData[
  FormBox["p", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "606cb52c-426a-44c2-baf8-3756d84116c8"],
 " is the number of parameters being estimated."
}], "Text",
 CellChangeTimes->{{3.7274567852393503`*^9, 3.727456791351314*^9}, {
  3.7274626311713448`*^9, 3.727462680678966*^9}, {3.727472647355248*^9, 
  3.727472725986993*^9}, {3.7274728947945757`*^9, 3.727472940968391*^9}, {
  3.727474911778737*^9, 3.727474913439685*^9}, {3.727475723944086*^9, 
  3.727475733135212*^9}},ExpressionUUID->"5a7bf6c2-c13d-475e-87fe-\
36638d65051a"],

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
   3.727472952057025*^9},ExpressionUUID->"77bcb811-ab22-4fdc-b1ae-\
15e20ad97470"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"0.002364918917426321`", 
      RowBox[{"-", "0.0023649189174263213`"}]},
     {
      RowBox[{"-", "0.002364918917426321`"}], "0.005571588635970485`"}
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
   3.727472137981408*^9, 
   3.727472954371911*^9},ExpressionUUID->"4c68b4b7-49bb-48fd-af69-\
7e94e7de81f0"]
}, Open  ]],

Cell["\<\
Except for the reversed order, this is the same covariance matrix that \
Wolfram reports:\
\>", "Text",
 CellChangeTimes->{{3.727454999214408*^9, 3.7274550230616837`*^9}, {
  3.7274550552077837`*^9, 3.727455069630582*^9}, {3.727456815268976*^9, 
  3.72745682043734*^9}, {3.727462715836411*^9, 
  3.7274627328032312`*^9}},ExpressionUUID->"5854e989-3d92-4d9e-929c-\
3ae81d1fa3da"],

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
  3.727455047125711*^9}},ExpressionUUID->"888bf0ed-8340-4f12-b5ec-\
6bb54ec5f270"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"0.00236491891742632`", 
      RowBox[{"-", "0.00236491891742632`"}]},
     {
      RowBox[{"-", "0.00236491891742632`"}], "0.005571588635970483`"}
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
   3.727462601420088*^9, 
   3.727472138034376*^9},ExpressionUUID->"b89c45e1-9da0-4896-a529-\
eaf9e5358b42"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Don\[CloseCurlyQuote]t Invert That Matrix\.7f", "Subchapter",
 CellChangeTimes->{{3.727456856590333*^9, 3.727456866525626*^9}, {
  3.727456903416147*^9, 
  3.727456929038941*^9}},ExpressionUUID->"261a962d-c8d5-4c63-bbe0-\
c1df49f68724"],

Cell["\<\
See https://www.johndcook.com/blog/2010/01/19/dont-invert-that-matrix/ \
\>", "Text",
 CellChangeTimes->{{3.727377065079856*^9, 3.7273770966536922`*^9}, {
  3.727456910929248*^9, 
  3.727456922321958*^9}},ExpressionUUID->"e2e2968f-3fa0-4d43-bfbd-\
75478af56790"],

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
   3.727457033259179*^9},ExpressionUUID->"9814b8fb-3545-4309-9810-\
48cf81950c33"],

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
   3.727473491340034*^9}},ExpressionUUID->"6de9570c-a054-4807-bd5a-\
d0054015e97d"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.49626175353239277`"},
       {
        RowBox[{"-", "0.28379023285043664`"}]}
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
   3.727473492609377*^9},ExpressionUUID->"de33170b-64c4-4fa3-928a-\
a783292b3bfd"]
}, Open  ]],

Cell["exactly as before.", "Text",
 CellChangeTimes->{{3.727473280120357*^9, 
  3.7274732832085*^9}},ExpressionUUID->"54eb156d-d6a7-4fe2-9022-6900412e22e4"],

Cell["\<\
We have eliminated memory bloat by accumulating estimate updates one \
observation at a time, with its paired partial. We reduce computation time \
and numerical risk by solving a linear system instead of inverting a matrix.\
\>", "Text",
 CellChangeTimes->{{3.727475777156247*^9, 
  3.727475832537896*^9}},ExpressionUUID->"af11b1f8-aef3-4e2d-858d-\
1c9cce0a4c0b"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["The Dual Problem", "Chapter",
 CellChangeTimes->{{3.7273771343297157`*^9, 
  3.727377139800111*^9}},ExpressionUUID->"066bda79-27bc-481d-9adb-\
7835a1ace4b4"],

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
  FormBox["\[CapitalTheta]", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "595110e6-8484-4e8f-924b-1631a75a7403"],
 " (replacing ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
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
     SubscriptBox[
      RowBox[{"\[CapitalTheta]", "\[Transpose]"}], 
      RowBox[{"so", "-", "far"}]]}]}], TraditionalForm]],
  FormatType->"TraditionalForm",ExpressionUUID->
  "3e9237e0-1492-41e0-9db9-9439ab6ebd6b"],
 ". We don\[CloseCurlyQuote]t need to change the name of \[CapitalLambda] \
because it\[CloseCurlyQuote]s symmetric. Adding a new observation ",
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
   3.7274761487187138`*^9}},ExpressionUUID->"8b28bbec-6b3d-4f92-9516-\
2debd387e4df"],

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
  3.727476415307171*^9}},ExpressionUUID->"09c80be1-77f4-41fa-a7ba-\
538f564cd5a2"],

Cell[TextData[{
 Cell[BoxData[
  FormBox["LinearSolve", TraditionalForm]], "Code",
  FormatType->"TraditionalForm",ExpressionUUID->
  "cb78cef6-6105-441c-b121-2693c4ccb84d"],
 " operates on the transposed right-hand side of the recurrence, and we \
transpose the solution to get the recurrence."
}], "Text",
 CellChangeTimes->{{3.727476457185042*^9, 3.727476506319212*^9}, {
  3.727476549477606*^9, 
  3.7274765535653963`*^9}},ExpressionUUID->"bcd2c5b4-c0c7-4831-a70a-\
0773f9b09908"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Transpose", "/@", 
  RowBox[{"List", "/@", 
   RowBox[{"partials", "\[LeftDoubleBracket]", 
    RowBox[{"1", ";;", "3"}], "\[RightDoubleBracket]"}]}]}]], "Input",
 CellChangeTimes->{{3.72747707307362*^9, 
  3.727477115704844*^9}},ExpressionUUID->"e782c37b-71c0-4c80-ac39-\
cfb0f97b2653"],

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
 CellChangeTimes->{{3.727477084780794*^9, 
  3.727477117039559*^9}},ExpressionUUID->"0ba9dc99-8482-4e7c-b9d0-\
25b49cd3de94"]
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
   3.7274775628692408`*^9}},ExpressionUUID->"6799c819-997a-4a6f-8b57-\
f9d3ce291e90"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.49626175353239277`", 
        RowBox[{"-", "0.28379023285043664`"}]}
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
   3.7274775639291077`*^9}},ExpressionUUID->"b8f80985-ccc9-4e6d-b48e-\
e51b96d3e21a"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Application of the Dual Problem", "Subchapter",
 CellChangeTimes->{{3.7274775822773733`*^9, 
  3.727477598570956*^9}},ExpressionUUID->"6beb485e-d330-483c-9891-\
d48d6c7aadb6"],

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
 ". We want to estimate its gradient co-vector  ",
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
  FormBox["\[Psi]", TraditionalForm]],ExpressionUUID->
  "26064a52-cf83-4405-a953-89d9699fa069"],
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
 ". "
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
   3.727477804771535*^9}},ExpressionUUID->"e1f59401-7db5-434e-9425-\
c6f88b8ff7d0"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
},
WindowSize->{1095, 851},
WindowMargins->{{0, Automatic}, {Automatic, 0}},
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
Cell[1510, 35, 226, 4, 139, "Title",ExpressionUUID->"0f858e27-6aa2-4959-ba50-014340204105"],
Cell[1739, 41, 177, 6, 103, "Text",ExpressionUUID->"bfc46f02-95be-4ccf-a54b-5729a6a2d2f1"],
Cell[CellGroupData[{
Cell[1941, 51, 165, 3, 101, "Chapter",ExpressionUUID->"ee617776-b99f-45f6-89dd-84ae49138941"],
Cell[2109, 56, 2518, 74, 164, "Text",ExpressionUUID->"400b70f9-1594-48bd-ac23-cd631be7153c"],
Cell[4630, 132, 1710, 49, 118, "DisplayFormulaNumbered",ExpressionUUID->"cff2b503-5678-48a0-9b30-a15bcb98c593"],
Cell[6343, 183, 354, 7, 72, "Text",ExpressionUUID->"a8cd1342-0d92-4914-ae2e-c3bf22e1811e"],
Cell[CellGroupData[{
Cell[6722, 194, 285, 5, 95, "Subchapter",ExpressionUUID->"439ef9a8-1611-4eb7-a71c-06c4f3290d82"],
Cell[7010, 201, 440, 8, 133, "Text",ExpressionUUID->"26b28091-0971-49e7-af89-f3543e79ade6"],
Cell[7453, 211, 560, 17, 95, "Input",ExpressionUUID->"d499b6bb-b246-4513-ae9b-014ceeb54501"]
}, Open  ]],
Cell[CellGroupData[{
Cell[8050, 233, 181, 3, 95, "Subchapter",ExpressionUUID->"b52bd5e9-51a4-4140-90af-c857568590d5"],
Cell[8234, 238, 1203, 30, 164, "Text",ExpressionUUID->"7a014088-0fdb-4074-b068-3a3e19edf249"],
Cell[CellGroupData[{
Cell[9462, 272, 1891, 42, 188, "Input",ExpressionUUID->"a7b3e667-1dac-4247-9849-dc483276a9da"],
Cell[11356, 316, 2114, 43, 112, "Output",ExpressionUUID->"b52e1848-4c40-4623-b1c0-57dc1e988072"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[13519, 365, 180, 3, 95, "Subchapter",ExpressionUUID->"1e9e9472-1ea4-47a7-9d39-116de0d05cf1"],
Cell[13702, 370, 1120, 28, 188, "Input",ExpressionUUID->"17ca9237-a02b-4905-a0af-29a0dd6e2c31"],
Cell[CellGroupData[{
Cell[14847, 402, 1421, 29, 157, "Input",ExpressionUUID->"8ce05715-92b7-422c-9ceb-2e30074647f7"],
Cell[16271, 433, 1797, 30, 112, "Output",ExpressionUUID->"0c9cdd6e-7f80-4288-bf15-5819a6bf59fa"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[18117, 469, 153, 3, 95, "Subchapter",ExpressionUUID->"0ef2e2ec-845b-4518-b5d3-5898a4387d1f"],
Cell[18273, 474, 519, 14, 72, "Text",ExpressionUUID->"0ef3d696-1f75-4a00-99ef-9d0dd81af8b5"],
Cell[CellGroupData[{
Cell[18817, 492, 874, 21, 126, "Input",ExpressionUUID->"3ade0ac4-2d53-47a7-ab68-3b9323459560"],
Cell[19694, 515, 1337, 22, 63, "Output",ExpressionUUID->"319b75a3-4760-4037-bd52-9821d0911ca5"]
}, Open  ]],
Cell[21046, 540, 347, 7, 103, "Text",ExpressionUUID->"04f2e82a-193d-4277-bf02-0d1fec304720"],
Cell[21396, 549, 649, 15, 63, "Input",ExpressionUUID->"cbd42705-9e56-4775-91bc-8faa382e378f"],
Cell[CellGroupData[{
Cell[22070, 568, 927, 24, 95, "Input",ExpressionUUID->"f6fa43c5-86da-458f-907b-a320e1c2a482"],
Cell[23000, 594, 8147, 151, 372, "Output",ExpressionUUID->"110cc4b0-bfa0-4932-8428-a35e4547e0c0"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[31196, 751, 312, 5, 95, "Subchapter",ExpressionUUID->"51a7bc1e-b7b8-43c8-9abf-cf6be427b759"],
Cell[31511, 758, 1899, 48, 140, "Text",ExpressionUUID->"8b5a501a-19e0-431a-9a5e-07b5f12e6dc6"],
Cell[33413, 808, 755, 17, 38, "DisplayFormulaNumbered",ExpressionUUID->"b2685cf4-e531-4006-a04f-1176adc74eef"],
Cell[34171, 827, 209, 4, 72, "Text",ExpressionUUID->"b67ab191-5f84-4595-aa41-9bc11cf8d5f3"],
Cell[CellGroupData[{
Cell[34405, 835, 378, 9, 63, "Input",ExpressionUUID->"693659ef-6e19-4c29-9130-8963286da21c"],
Cell[34786, 846, 1135, 19, 63, "Output",ExpressionUUID->"3c79d10c-9da3-49ad-bb3e-4950d7e8d089"]
}, Open  ]],
Cell[35936, 868, 607, 19, 72, "Text",ExpressionUUID->"51e339e6-b089-40aa-8980-efce3de6b1bd"],
Cell[CellGroupData[{
Cell[36568, 891, 285, 8, 63, "Input",ExpressionUUID->"e35bf53b-c8ea-42ea-98db-1836a2b88fdf"],
Cell[36856, 901, 928, 16, 63, "Output",ExpressionUUID->"0e3eb4a9-f7b1-4e63-afb6-52e65014ab5f"]
}, Open  ]],
Cell[37799, 920, 896, 21, 133, "Text",ExpressionUUID->"ea8aa4be-9c5c-4b1b-bb48-2947585b26ff"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[38744, 947, 205, 4, 101, "Chapter",ExpressionUUID->"18ffab3e-2f16-4b28-bab9-c79d3fbbb6d6"],
Cell[38952, 953, 773, 19, 72, "Text",ExpressionUUID->"4b62ee72-d304-4670-bf4f-815c69daf0c5"],
Cell[39728, 974, 1047, 27, 72, "DisplayFormulaNumbered",ExpressionUUID->"a6a743a0-cd50-41f5-acb6-d2bae2e6dbb2"],
Cell[40778, 1003, 2152, 49, 72, "Text",ExpressionUUID->"cfbf3ba5-f976-4b14-8254-984c44b6046d"],
Cell[42933, 1054, 4128, 106, 225, "Text",ExpressionUUID->"e646dc85-5149-4893-8b11-5d42f8e61f47"],
Cell[47064, 1162, 2693, 68, 135, "Text",ExpressionUUID->"dff38e8d-87b6-4201-8e23-8c819b678125"],
Cell[CellGroupData[{
Cell[49782, 1234, 3568, 82, 347, "Input",ExpressionUUID->"d51673f1-85e2-4a7e-8c9f-e8d6e2bcd55d"],
Cell[53353, 1318, 1539, 41, 84, "Output",ExpressionUUID->"dea96303-7bb8-4a6e-9a65-c66dcd615aff"]
}, Open  ]],
Cell[54907, 1362, 796, 18, 72, "Text",ExpressionUUID->"ebb721f6-a49a-4eb7-a219-38c6279512cc"],
Cell[55706, 1382, 471, 11, 103, "Text",ExpressionUUID->"d6ebfc40-1325-46f2-8e54-1afec927e438"],
Cell[56180, 1395, 1043, 27, 72, "Text",ExpressionUUID->"19a8376c-990f-43f2-84a6-ad48f08b1aa9"],
Cell[CellGroupData[{
Cell[57248, 1426, 304, 7, 63, "Input",ExpressionUUID->"10c385cd-d54b-4bb2-b548-a50b2024fa75"],
Cell[57555, 1435, 638, 14, 66, "Output",ExpressionUUID->"9a40e403-635d-4e8b-b899-ca73675e41f6"]
}, Open  ]],
Cell[58208, 1452, 2962, 77, 265, "Text",ExpressionUUID->"5a7bf6c2-c13d-475e-87fe-36638d65051a"],
Cell[CellGroupData[{
Cell[61195, 1533, 915, 22, 120, "Input",ExpressionUUID->"77bcb811-ab22-4fdc-b1ae-15e20ad97470"],
Cell[62113, 1557, 1253, 28, 101, "Output",ExpressionUUID->"4c68b4b7-49bb-48fd-af69-7e94e7de81f0"]
}, Open  ]],
Cell[63381, 1588, 388, 8, 72, "Text",ExpressionUUID->"5854e989-3d92-4d9e-929c-3ae81d1fa3da"],
Cell[CellGroupData[{
Cell[63794, 1600, 441, 12, 63, "Input",ExpressionUUID->"888bf0ed-8340-4f12-b5ec-6bb54ec5f270"],
Cell[64238, 1614, 1096, 26, 101, "Output",ExpressionUUID->"b89c45e1-9da0-4896-a529-eaf9e5358b42"]
}, Open  ]],
Cell[CellGroupData[{
Cell[65371, 1645, 242, 4, 95, "Subchapter",ExpressionUUID->"261a962d-c8d5-4c63-bbe0-c1df49f68724"],
Cell[65616, 1651, 272, 6, 72, "Text",ExpressionUUID->"e2e2968f-3fa0-4d43-bfbd-75478af56790"],
Cell[65891, 1659, 505, 14, 72, "Text",ExpressionUUID->"9814b8fb-3545-4309-9810-48cf81950c33"],
Cell[CellGroupData[{
Cell[66421, 1677, 3269, 78, 316, "Input",ExpressionUUID->"6de9570c-a054-4807-bd5a-d0054015e97d"],
Cell[69693, 1757, 1494, 40, 84, "Output",ExpressionUUID->"de33170b-64c4-4fa3-928a-a783292b3bfd"]
}, Open  ]],
Cell[71202, 1800, 156, 2, 72, "Text",ExpressionUUID->"54eb156d-d6a7-4fe2-9022-6900412e22e4"],
Cell[71361, 1804, 374, 7, 133, "Text",ExpressionUUID->"af11b1f8-aef3-4e2d-858d-1c9cce0a4c0b"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[71784, 1817, 163, 3, 101, "Chapter",ExpressionUUID->"066bda79-27bc-481d-9adb-7835a1ace4b4"],
Cell[71950, 1822, 5062, 104, 225, "Text",ExpressionUUID->"8b28bbec-6b3d-4f92-9516-2debd387e4df"],
Cell[77015, 1928, 1099, 27, 72, "DisplayFormulaNumbered",ExpressionUUID->"09c80be1-77f4-41fa-a7ba-538f564cd5a2"],
Cell[78117, 1957, 484, 11, 103, "Text",ExpressionUUID->"bcd2c5b4-c0c7-4831-a70a-0773f9b09908"],
Cell[CellGroupData[{
Cell[78626, 1972, 311, 7, 63, "Input",ExpressionUUID->"e782c37b-71c0-4c80-ac39-cfb0f97b2653"],
Cell[78940, 1981, 622, 20, 63, "Output",ExpressionUUID->"0ba9dc99-8482-4e7c-b9d0-25b49cd3de94"]
}, Open  ]],
Cell[CellGroupData[{
Cell[79599, 2006, 2690, 66, 326, "Input",ExpressionUUID->"6799c819-997a-4a6f-8b57-f9d3ce291e90"],
Cell[82292, 2074, 2448, 53, 84, "Output",ExpressionUUID->"b8f80985-ccc9-4e6d-b48e-e51b96d3e21a"]
}, Open  ]],
Cell[CellGroupData[{
Cell[84777, 2132, 181, 3, 95, "Subchapter",ExpressionUUID->"6beb485e-d330-483c-9891-d48d6c7aadb6"],
Cell[84961, 2137, 6529, 159, 264, "Text",ExpressionUUID->"e1f59401-7db5-434e-9425-c6f88b8ff7d0"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature xwTGFuxCBt2NoBKWQ6AgC0zB *)
