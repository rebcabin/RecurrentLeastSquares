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
NotebookDataLength[    458130,      10050]
NotebookOptionsPosition[    432470,       9603]
NotebookOutlinePosition[    436003,       9695]
CellTagsIndexPosition[    435593,       9676]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell["Efficient Bayesian Regularization \[LineSeparator]by Kalman Folding", \
"Title",
 CellChangeTimes->{{3.727038100871808*^9, 3.727038119380846*^9}, {
  3.727471593317396*^9, 3.7274715984595823`*^9}, {3.729120277549485*^9, 
  3.729120279330949*^9}, {3.729164818218039*^9, 3.729164831400428*^9}, {
  3.72917959045429*^9, 3.7291795965711203`*^9}, {3.7291976388841267`*^9, 
  3.729197641402032*^9}},
 CellTags->"c:1",ExpressionUUID->"d98080dc-278f-4830-9197-07efd2633fa4"],

Cell["\<\
Brian Beckman
11 Mar 2018\
\>", "Text",
 CellChangeTimes->{{3.727471602355763*^9, 3.7274716101393967`*^9}, {
   3.727925773402236*^9, 3.727925775055613*^9}, {3.7291796049113493`*^9, 
   3.729179606176675*^9}, 3.729642307282371*^9, {3.72971195796128*^9, 
   3.729711959054461*^9}, {3.7297934248121*^9, 
   3.729793424979403*^9}},ExpressionUUID->"7cf3aefa-42f7-4a77-93d4-\
058e0c84664a"],

Cell[CellGroupData[{

Cell["Abstract", "Chapter",
 CellChangeTimes->{{3.729196441150124*^9, 3.7291964428392887`*^9}, {
  3.729793427963233*^9, 
  3.7297934299790154`*^9}},ExpressionUUID->"8acf63cd-c62f-4726-abe0-\
425d6b54818d"],

Cell["\<\
We show, by numerical examples, that Kalman folding (KAL) produces the same \
results as recurrent least squares (RLS) and maximum a-posteriori (MAP), for \
appropriate choices of a-priori covariances, i.e., regularization \
hyperparameters. KAL and RLS are more intuitive than MAP for practical \
applications, plus offer space-time efficiency over MAP by avoiding storage \
and multiplication of large matrices. Because RLS and KAL are overt \
recurrences, a-priori data are necessary to bootstrap them, so regularization \
is naturally built-in to the formulation: they are Bayesian by construction. \
Contrast MAP, wherein a-priori belief is introduced as a Bayesian \
modification of traditional, maximum-likelihood (MLE) least-squares through \
the normal equations. 

We exploit the novel fact that MAP is invariant when its hyperparameters are \
both swapped and inverted. After that transformation, the MAP equations \
strongly resemble the equations of Kalman filtering. This resemblance may \
suggest a future, general proof of the invariance, perhaps by conversion of \
MAP from explicit to recurrent form.\
\>", "Text",
 CellChangeTimes->{{3.7291964484304113`*^9, 3.729196613945616*^9}, 
   3.7292030970835457`*^9, {3.72968771341329*^9, 3.729687716858973*^9}, {
   3.729711791511696*^9, 3.72971179468015*^9}, {3.729793438706923*^9, 
   3.7297938892411823`*^9}, {3.729793935626384*^9, 3.729793942511643*^9}, {
   3.729793972831012*^9, 3.7297939745590477`*^9}, {3.729794610127033*^9, 
   3.729794682412895*^9}, {3.729794964535297*^9, 3.729795210547194*^9}, {
   3.729795571545514*^9, 3.7297956107276*^9}, {3.729796915642858*^9, 
   3.729796923833707*^9}, 
   3.729885268229594*^9},ExpressionUUID->"f91d8029-0f04-4263-854f-\
1f318b8699ff"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Introduction", "Chapter",
 CellChangeTimes->{{3.727481450088695*^9, 3.7274814520560217`*^9}, {
  3.729180217802278*^9, 3.7291802195774593`*^9}, {3.729793433035008*^9, 
  3.729793435162754*^9}},
 CellTags->"c:2",ExpressionUUID->"3c14fe8e-8c74-403e-919a-d59e78c17505"],

Cell[TextData[{
 "Linear systems appear everywhere, and, where they don\[CloseCurlyQuote]t \
appear naturally, linear approximations abound because non-linear systems are \
often intractable. Examples comprise machine learning, control, dynamics, \
robotics, and many more. \n\n",
 StyleBox["Linear regression",
  FontSlant->"Italic"],
 " is the standard technique for estimating coefficients or ",
 StyleBox["parameters",
  FontSlant->"Italic"],
 " of a linear model from given data. Often, authors sweep linear regression \
under the rug, presumably because readers know all about it. However, time \
and again, I see the normal equations directly applied (fat, slow, \
over-fitting), \.7fmatrices inverted (risky), and neural networks applied \
(overkill).\n\nOver-fitting is another hazard. Linear models, as their ",
 StyleBox["order",
  FontSlant->"Italic"],
 " (number of parameters) nears or exceeds the number of data points, tend to \
follow data too well, limiting smoothness and predictive power outside the \
bounds of the data. Models that over-fit \[OpenCurlyDoubleQuote]wiggle\
\[CloseCurlyDoubleQuote] too much and ",
 StyleBox["generalize",
  FontSlant->"Italic"],
 " poorly.\n\n",
 StyleBox["Regularization",
  FontSlant->"Italic"],
 " is the usual mitigation of over-fitting. In Bayesian MAP, regularization \
is introduced through a-priori ",
 StyleBox["belief",
  FontSlant->"Italic"],
 " hyperparameters ",
 Cell[BoxData[
  FormBox["\[Alpha]", TraditionalForm]],ExpressionUUID->
  "2e094fd1-d320-48fa-8784-29b632121441"],
 " and ",
 Cell[BoxData[
  FormBox["\[Beta]", TraditionalForm]],ExpressionUUID->
  "06e7edf1-7609-40b5-bbb0-0ebee319dafe"],
 ", the reciprocal variance of an a-priori estimate of the unknown parameters \
of the model, and the variance of the observations from the model, \
respectively. \n\nWe show here, numerically, that MAP produces the same \
results when ",
 Cell[BoxData[
  FormBox["\[Alpha]", TraditionalForm]],ExpressionUUID->
  "3f9a0544-efa5-4cce-bb42-6d76b9af5b08"],
 " and ",
 Cell[BoxData[
  FormBox["\[Beta]", TraditionalForm]],ExpressionUUID->
  "b54789e4-b2ba-4e13-af91-61734cd5d755"],
 " are swapped and inverted. After that transformation, the MAP equations \
strongly resemble the equations of Kalman filtering, promoting intuition in \
applications. Applied directly, rather than as reciprocals, and in opposite \
positions from MAP, these variances are concrete and can be estimated or \
learned directly from experimental conditions. \n\nRLS and KAL also offer \
scaling advantages over MAP (see ",
 ButtonBox["Beckman\[CloseCurlyQuote]s series on Kalman folding at \
https://goo.gl/iTxTzs",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["https://github.com/rebcabin/kalman-folding"], None},
  ButtonNote->"https://github.com/rebcabin/kalman-folding"],
 "). MAP is a  modification of the ",
 StyleBox["normal equations",
  FontSlant->"Italic"],
 " of maximum-likelihood (MLE) regression. The normal equations and the MAP \
equations suggest explicit computation over whole data sets. There is no \
obvious way to convert them into recurrences. RLS and KAL, however, overtly \
process data one observation at a time, avoiding storage and multiplication \
of large matrices. RLS and KAL have natural expressions as ",
 StyleBox["functional folds",
  FontSlant->"Italic"],
 ", fitting into contemporary programming languages. "
}], "Text",
 CellChangeTimes->{{3.7274814553838453`*^9, 3.727481471849703*^9}, {
   3.727481502548395*^9, 3.727481543290386*^9}, {3.7274815762427998`*^9, 
   3.727481597731824*^9}, {3.727481661069376*^9, 3.7274817001125383`*^9}, {
   3.727481803352981*^9, 3.727481863536408*^9}, {3.7274819760213203`*^9, 
   3.727481983533637*^9}, {3.72748203670294*^9, 3.727482052238491*^9}, {
   3.727482189409683*^9, 3.727482202321042*^9}, {3.727482237078443*^9, 
   3.7274824455142107`*^9}, {3.727482502224814*^9, 3.727482511663734*^9}, {
   3.727482542628716*^9, 3.727482573300147*^9}, {3.7274826061847153`*^9, 
   3.727482641957479*^9}, {3.727483068187994*^9, 3.72748306969718*^9}, {
   3.727483495698502*^9, 3.727483517296239*^9}, {3.727483586049469*^9, 
   3.7274836308700047`*^9}, {3.7274837441660624`*^9, 3.727483765339192*^9}, 
   3.7274838852467213`*^9, {3.7279259770520372`*^9, 3.727926056795493*^9}, {
   3.727927567316916*^9, 3.7279276585683327`*^9}, {3.727965622939703*^9, 
   3.727965628844901*^9}, {3.7279657010285673`*^9, 3.727965810694715*^9}, {
   3.728090783678996*^9, 3.728090785427752*^9}, {3.728090821738459*^9, 
   3.7280909405099163`*^9}, {3.72916210505669*^9, 3.7291621946893387`*^9}, {
   3.729162225195818*^9, 3.729162512932467*^9}, {3.729164726885667*^9, 
   3.729164884422428*^9}, {3.7291795375260077`*^9, 3.729179581270995*^9}, {
   3.729179619964759*^9, 3.729180297389501*^9}, {3.7291803726342297`*^9, 
   3.729180703771147*^9}, {3.7291812861388683`*^9, 3.729181349663971*^9}, {
   3.7296423196925898`*^9, 3.729642550146667*^9}, {3.729794000505768*^9, 
   3.729794021508069*^9}, {3.729794071613781*^9, 3.729794080908226*^9}, {
   3.729794125149901*^9, 3.7297942448527946`*^9}, {3.7297943254956703`*^9, 
   3.729794591812196*^9}, {3.7297947291482353`*^9, 3.729794806053865*^9}, {
   3.729794850239337*^9, 3.7297949381799383`*^9}, {3.729795222271432*^9, 
   3.729795252056612*^9}, {3.729795296933094*^9, 3.7297955335461597`*^9}, {
   3.729795625169161*^9, 3.72979570950813*^9}, {3.729795770236939*^9, 
   3.729795773761647*^9}, {3.729796088260374*^9, 
   3.729796150829298*^9}},ExpressionUUID->"95303209-19a9-46b4-b2e8-\
754c3c3dff50"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Motivating Review", "Chapter",
 CellChangeTimes->{{3.727448922904108*^9, 3.7274489260707684`*^9}, {
  3.7297961891455393`*^9, 3.729796190065695*^9}},
 CellTags->"c:3",ExpressionUUID->"acc655e3-2c6d-44c7-a5e2-4f24850f83fb"],

Cell[TextData[{
 "First, we exhibit ",
 StyleBox["maximum-likelihood estimation (MLE)",
  Background->None],
 " for a problem of order two: estimating the slope and intercept of a \
best-fit line to noisy data. This example puts an elementary problem into a \
setting that we generalize to higher order below. Furthermore, MLE ",
 StyleBox["operates over all the data at once",
  FontSlant->"Italic"],
 ", requiring matrices full of data to be stored, multiplied, and inverted. \
Not until we get to RLS and KAL do we see approaches much more efficient in \
memory and time.\n\nMLE is computed four ways: "
}], "Text",
 CellChangeTimes->{{3.728090971639092*^9, 3.728091137803318*^9}, {
   3.729162525262968*^9, 3.7291625523646097`*^9}, {3.729162594386468*^9, 
   3.729162644882078*^9}, {3.729180713797406*^9, 3.7291809759860487`*^9}, {
   3.729182777816757*^9, 3.729182779123023*^9}, {3.7291914192080936`*^9, 
   3.729191421173909*^9}, {3.729191463421255*^9, 3.729191512351722*^9}, {
   3.7295528209947367`*^9, 3.7295529738343067`*^9}, {3.729553031138538*^9, 
   3.7295530645530767`*^9}, {3.729553105041057*^9, 3.729553167790482*^9}, {
   3.7295532207179813`*^9, 3.7295532291625338`*^9}, {3.729642617580188*^9, 
   3.7296426611004972`*^9}, {3.72964271057891*^9, 3.72964271161131*^9}, 
   3.7297962068854017`*^9, {3.729796237410095*^9, 3.729796270643283*^9}, {
   3.729796301832774*^9, 
   3.7297963166712847`*^9}},ExpressionUUID->"54f362df-f60e-482e-a1c7-\
1c9e97a26ec4"],

Cell[CellGroupData[{

Cell["using Wolfram built-in functions", "ItemNumbered",
 CellChangeTimes->{{3.728090971639092*^9, 3.728091137803318*^9}, {
  3.729162525262968*^9, 3.7291625523646097`*^9}, {3.729162594386468*^9, 
  3.729162644882078*^9}, {3.729180713797406*^9, 3.7291809759860487`*^9}, {
  3.729182777816757*^9, 3.729182779123023*^9}, {3.7291914192080936`*^9, 
  3.729191421173909*^9}, {3.729191463421255*^9, 3.729191512351722*^9}, {
  3.7295528209947367`*^9, 3.7295529738343067`*^9}, {3.729553031138538*^9, 
  3.7295530645530767`*^9}, {3.729553105041057*^9, 3.729553167790482*^9}, {
  3.7295532207179813`*^9, 3.7295532291625338`*^9}, {3.729642617580188*^9, 
  3.729642669989204*^9}, {3.729642705230754*^9, 
  3.729642708875139*^9}},ExpressionUUID->"95439e47-910a-4dca-b38c-\
a75f8ec21e0d"],

Cell["directly through the classic normal equations", "ItemNumbered",
 CellChangeTimes->{{3.728090971639092*^9, 3.728091137803318*^9}, {
  3.729162525262968*^9, 3.7291625523646097`*^9}, {3.729162594386468*^9, 
  3.729162644882078*^9}, {3.729180713797406*^9, 3.7291809759860487`*^9}, {
  3.729182777816757*^9, 3.729182779123023*^9}, {3.7291914192080936`*^9, 
  3.729191421173909*^9}, {3.729191463421255*^9, 3.729191512351722*^9}, {
  3.7295528209947367`*^9, 3.7295529738343067`*^9}, {3.729553031138538*^9, 
  3.7295530645530767`*^9}, {3.729553105041057*^9, 3.729553167790482*^9}, {
  3.7295532207179813`*^9, 3.7295532291625338`*^9}, {3.729642617580188*^9, 
  3.729642703803406*^9}},ExpressionUUID->"ad86a253-cdd7-442a-8329-\
f48d9394f90e"],

Cell["using the Moore-Penrose left pseudoinverse", "ItemNumbered",
 CellChangeTimes->{{3.728090971639092*^9, 3.728091137803318*^9}, {
  3.729162525262968*^9, 3.7291625523646097`*^9}, {3.729162594386468*^9, 
  3.729162644882078*^9}, {3.729180713797406*^9, 3.7291809759860487`*^9}, {
  3.729182777816757*^9, 3.729182779123023*^9}, {3.7291914192080936`*^9, 
  3.729191421173909*^9}, {3.729191463421255*^9, 3.729191512351722*^9}, {
  3.7295528209947367`*^9, 3.7295529738343067`*^9}, {3.729553031138538*^9, 
  3.7295530645530767`*^9}, {3.729553105041057*^9, 3.729553167790482*^9}, {
  3.7295532207179813`*^9, 3.7295532291625338`*^9}, {3.729642617580188*^9, 
  3.7296427014033957`*^9}},ExpressionUUID->"767c9503-7598-4cb2-af44-\
f17424f2cfa1"],

Cell["sidestepping the risky inverse by solving a linear system", \
"ItemNumbered",
 CellChangeTimes->{{3.728090971639092*^9, 3.728091137803318*^9}, {
  3.729162525262968*^9, 3.7291625523646097`*^9}, {3.729162594386468*^9, 
  3.729162644882078*^9}, {3.729180713797406*^9, 3.7291809759860487`*^9}, {
  3.729182777816757*^9, 3.729182779123023*^9}, {3.7291914192080936`*^9, 
  3.729191421173909*^9}, {3.729191463421255*^9, 3.729191512351722*^9}, {
  3.7295528209947367`*^9, 3.7295529738343067`*^9}, {3.729553031138538*^9, 
  3.7295530645530767`*^9}, {3.729553105041057*^9, 3.729553167790482*^9}, {
  3.7295532207179813`*^9, 3.7295532291625338`*^9}, {3.729642617580188*^9, 
  3.729642697209589*^9}, {3.7296427333059397`*^9, 3.729642738112775*^9}, {
  3.729892321626854*^9, 
  3.729892321934926*^9}},ExpressionUUID->"d0e1a7c9-95a9-43bd-b642-\
8f6260b3fff4"]
}, Open  ]],

Cell["\<\
These methods of MLE yield exactly the same results for this small example. \
It is easy to make them diverge numerically for models with more parameters, \
that is, of larger order. \
\>", "Text",
 CellChangeTimes->{{3.728090971639092*^9, 3.728091137803318*^9}, {
  3.729162525262968*^9, 3.7291625523646097`*^9}, {3.729162594386468*^9, 
  3.729162644882078*^9}, {3.729180713797406*^9, 3.7291809759860487`*^9}, {
  3.729182777816757*^9, 3.729182779123023*^9}, {3.7291914192080936`*^9, 
  3.729191421173909*^9}, {3.729191463421255*^9, 3.729191512351722*^9}, {
  3.7295528209947367`*^9, 3.7295529738343067`*^9}, {3.729553031138538*^9, 
  3.7295530645530767`*^9}, {3.729553105041057*^9, 3.729553167790482*^9}, {
  3.7295532207179813`*^9, 3.7295532291625338`*^9}, {3.729642617580188*^9, 
  3.729642692379868*^9}, {3.729642750810244*^9, 3.729642753623979*^9}, {
  3.7297963357540913`*^9, 
  3.729796336620441*^9}},ExpressionUUID->"aa3ac913-c0e3-49b0-a045-\
d5d44d7ce155"],

Cell[CellGroupData[{

Cell["Problem Statement", "Subchapter",
 CellChangeTimes->{{3.729642799531767*^9, 
  3.729642803227457*^9}},ExpressionUUID->"0c44a683-0d5b-4886-b75e-\
504c0d98a960"],

Cell[TextData[{
 "Find best-fit, unknown parameters ",
 Cell[BoxData[
  FormBox["m", TraditionalForm]],ExpressionUUID->
  "23d9cfff-f3b2-481a-b6b0-b0dd5f9b1280"],
 " (slope) and ",
 Cell[BoxData[
  FormBox["b", TraditionalForm]],ExpressionUUID->
  "26440a3d-fedb-4ee7-bb0c-8168bf0e1838"],
 " (intercept), where ",
 Cell[BoxData[
  FormBox[
   RowBox[{"z", "=", 
    RowBox[{
     RowBox[{"m", " ", "x"}], "+", "b"}]}], TraditionalForm]],ExpressionUUID->
  "327c6fd2-96f6-4323-8eb6-291777ee6a3a"],
 ", given known, noisy data ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{
     SubscriptBox["z", "1"], ",", 
     SubscriptBox["z", "2"], ",", "\[Ellipsis]", ",", 
     SubscriptBox["z", "\[CapitalNu]"]}], ")"}], TraditionalForm]],
  ExpressionUUID->"75075c60-5e3c-42da-b661-296a1ae1ee60"],
 " and ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{
     SubscriptBox["x", "1"], ",", 
     SubscriptBox["x", "2"], ",", "\[Ellipsis]", ",", 
     SubscriptBox["x", "\[CapitalNu]"]}], ")"}], TraditionalForm]],
  ExpressionUUID->"46e64d18-1f5c-4926-95b8-33f6a7ecf798"],
 ". \n\nWrite this ",
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
 StyleBox["model",
  FontSlant->"Italic",
  Background->RGBColor[1, 1, 0]],
 StyleBox[", state, unknown parameters",
  FontSlant->"Italic"],
 " to be estimated). \n\nRows of ",
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
  3.727471663001911*^9}, {3.7274858550759478`*^9, 3.727485860274253*^9}, {
  3.728091149168085*^9, 3.728091201530199*^9}, {3.729162651880166*^9, 
  3.7291627523168507`*^9}, {3.729162841547649*^9, 3.729162848090231*^9}, {
  3.729642807195567*^9, 3.72964282455161*^9}, {3.7297963463658*^9, 
  3.729796348669681*^9}, {3.729892358974674*^9, 
  3.7298923738130217`*^9}},ExpressionUUID->"358c38cb-da9b-497b-888a-\
d2c3526ecc8f"],

Cell[BoxData[{
 FormBox[
  RowBox[{
   RowBox[{
    SubscriptBox["\[CapitalZeta]", 
     RowBox[{"\[ThinSpace]", 
      RowBox[{"\[CapitalNu]", "\[Times]", "1"}]}]], "  ", "=", "  ", 
    RowBox[{
     RowBox[{"(", GridBox[{
        {
         SubscriptBox["z", "1"]},
        {
         SubscriptBox["z", "2"]},
        {"\[VerticalEllipsis]"},
        {
         SubscriptBox["z", "\[CapitalNu]"]}
       }], ")"}], "   ", "=", "   ", 
     RowBox[{
      RowBox[{
       RowBox[{"(", GridBox[{
          {
           SubscriptBox["x", "1"], "1"},
          {
           SubscriptBox["x", "2"], "1"},
          {"\[VerticalEllipsis]", "\[VerticalEllipsis]"},
          {
           SubscriptBox["x", "\[CapitalNu]"], "1"}
         }], ")"}], "  ", "\[CenterDot]", "  ", 
       RowBox[{"(", GridBox[{
          {
           SubscriptBox["m", "unknown"]},
          {
           SubscriptBox["b", "unknown"]}
         }], ")"}]}], "   ", "+", "  ", "noise"}]}]}], "   "}], 
  TraditionalForm], "\[LineSeparator]", 
 FormBox[
  RowBox[{"=", "  ", 
   RowBox[{
    RowBox[{
     SubscriptBox["A", 
      RowBox[{"\[ThinSpace]", 
       RowBox[{"\[CapitalNu]", "\[Times]", "2"}]}]], "\[CenterDot]", 
     SubscriptBox["\[CapitalXi]", 
      RowBox[{"\[ThinSpace]", 
       RowBox[{"2", "\[Times]", "1"}]}]]}], "  ", "+", "  ", 
    RowBox[{"samples", " ", "of", " ", 
     RowBox[{"NormalDistribution", "[", 
      RowBox[{"0", ",", 
       SubscriptBox["\[Sigma]", "\[CapitalZeta]"]}], "]"}]}]}]}], 
  TraditionalForm]}], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.727431219978753*^9, 3.7274313049913387`*^9}, {
  3.72743141969454*^9, 3.7274316161107063`*^9}, {3.727431991078349*^9, 
  3.727431991079677*^9}, {3.727433277603713*^9, 3.727433294425931*^9}, {
  3.727440753860702*^9, 3.7274407556831503`*^9}, {3.7274408733251953`*^9, 
  3.727440951766347*^9}, {3.727441005231421*^9, 3.727441018782874*^9}, {
  3.727471698016046*^9, 3.727471719286708*^9}, {3.7289478978830757`*^9, 
  3.728947929231979*^9}, {3.728948042008193*^9, 3.7289480682892017`*^9}, {
  3.72979637262674*^9, 
  3.72979641776385*^9}},ExpressionUUID->"7670c17b-1586-49cb-811e-\
f9d6e711742b"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Ground Truth", "Subchapter",
 CellChangeTimes->{{3.727038130736038*^9, 3.727038133799975*^9}, {
   3.727038190200441*^9, 3.727038194262557*^9}, {3.7270382668439693`*^9, 
   3.727038273195747*^9}, 3.727449676637067*^9},
 CellTags->"c:4",ExpressionUUID->"16970f90-0ae5-4547-a932-f6511f887bd9"],

Cell[TextData[{
 "Fake some data by (1) sampling a line specified by ",
 StyleBox["ground truth",
  FontSlant->"Italic",
  Background->RGBColor[1, 1, 0]],
 " ",
 Cell[BoxData[
  FormBox["m", TraditionalForm]],ExpressionUUID->
  "a6958922-45d9-44d5-a140-5d74dfa03120"],
 " and ",
 Cell[BoxData[
  FormBox["b", TraditionalForm]],ExpressionUUID->
  "39031738-b4df-4535-8d32-6ba1d755ca94"],
 ", then (2) adding Gaussian noise. Run the faked data through the four \
estimation procedures and see how close the estimated ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["m", "estimated"], TraditionalForm]],ExpressionUUID->
  "7d3a917e-e714-40a5-94eb-7b389b102b52"],
 " and ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["b", "estimated"], TraditionalForm]],ExpressionUUID->
  "130f7ec9-23b1-4ada-a060-010d925dcafa"],
 " come to the ground truth. \n\nIn real-world applications, we rarely have \
ground truth. Its purpose is to baseline or calibrate the various methods."
}], "Text",
 CellChangeTimes->{{3.7274717486938457`*^9, 3.727471863121015*^9}, {
   3.727471943951993*^9, 3.727471974860942*^9}, 3.7274752992891693`*^9, {
   3.727485889951729*^9, 3.727485910971366*^9}, {3.727485957242045*^9, 
   3.727485990073215*^9}, {3.727877625333728*^9, 3.727877661014937*^9}, {
   3.727877785098357*^9, 3.727877790057716*^9}, {3.728091354555441*^9, 
   3.728091378646338*^9}, {3.729162811973446*^9, 3.729162819633565*^9}, {
   3.7291628558399363`*^9, 3.729162932572029*^9}, {3.729181028160221*^9, 
   3.72918106154837*^9}, {3.7296428409291563`*^9, 3.729642850910636*^9}, {
   3.729796453908016*^9, 
   3.7297964759964657`*^9}},ExpressionUUID->"3c5928ca-5308-4a06-8fb9-\
200938bdc108"],

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
  3.727450221204816*^9}},ExpressionUUID->"0c0d0138-50fd-4e04-ac62-\
6a9945dc8b11"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Partials", "Subchapter",
 CellChangeTimes->{{3.727038381072097*^9, 3.7270383858220654`*^9}, 
   3.727472022244463*^9},
 CellTags->"c:5",ExpressionUUID->"4d7a0fc5-1456-46d8-85a7-51f164a04474"],

Cell[TextData[{
 "The partials ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "9309b19a-9472-465f-84be-8ecd35011dde"],
 " are a (order-",
 Cell[BoxData[
  FormBox["\[CapitalNu]", TraditionalForm]],ExpressionUUID->
  "ae8db516-cb35-42df-90bb-15aa620bf7ce"],
 " column) vector of covectors (order-",
 Cell[BoxData[
  FormBox["\[CapitalMu]", TraditionalForm]],ExpressionUUID->
  "a2ba7cf0-657a-4b1e-8900-015915a1c1d9"],
 " row vectors). Each covector is the gradient 1-form of ",
 Cell[BoxData[
  FormBox[
   RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}], TraditionalForm]],
  ExpressionUUID->"24f492e1-8cbc-4b9e-85e3-f2475b30584a"],
 " with respect to ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "32a3d80d-1e15-455e-a684-128e0a220123"],
 ", evaluated at specific values of ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "482810e6-322f-4783-a84c-dc625d8b0917"],
 " from the data. Gradients are best viewed as 1-forms, always",
 StyleBox[" covectors:",
  FontWeight->"Plain"],
 " linear transformations of vectors. "
}], "Text",
 CellChangeTimes->{{3.727474059032774*^9, 3.727474241042626*^9}, {
  3.727475321236279*^9, 3.727475337122877*^9}, {3.727877875957012*^9, 
  3.727877901401568*^9}, {3.728091432235373*^9, 3.728091454599753*^9}, {
  3.7291191792753353`*^9, 3.7291191793375893`*^9}, {3.729162951360962*^9, 
  3.729163067652018*^9}, {3.7291810738050528`*^9, 3.729181098851663*^9}, {
  3.7297964988703747`*^9, 
  3.729796563292739*^9}},ExpressionUUID->"a86b4f51-45ea-41db-81c3-\
c906e76e98d5"],

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
   3.727472063729579*^9}},ExpressionUUID->"ee0a7bb0-e686-4680-8f50-\
8cd48901d6c9"],

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
   3.727462600894341*^9, 3.7274720648603897`*^9, 3.727472137401977*^9, 
   3.727485510677791*^9, 3.727486308137322*^9, 3.727878577703927*^9, 
   3.727880786980283*^9, 3.727881187293543*^9, 3.727881367162183*^9, 
   3.7279153846145782`*^9, 3.727918036001253*^9, 3.727918094003922*^9, 
   3.727924197077376*^9, {3.7279277061564293`*^9, 3.7279277315954943`*^9}, 
   3.727967809713481*^9, 3.72796873270875*^9, 3.727969807680747*^9, 
   3.727969954624679*^9, 3.728044351074147*^9, 3.72804644720837*^9, 
   3.728066469128708*^9, 3.728068120342204*^9, 3.728083782832687*^9, 
   3.7280907407468643`*^9, 3.728169444417408*^9, 3.72816954001482*^9, 
   3.728169822168985*^9, 3.7281698821964903`*^9, 3.728252954623953*^9, 
   3.728946255244152*^9, 3.729022899498974*^9, {3.7291199776963177`*^9, 
   3.729119994943653*^9}, 3.729121071330551*^9, 3.729121109944316*^9, 
   3.729172306734695*^9, 3.7291756896573877`*^9, 3.729175732578528*^9, 
   3.729183411371399*^9, {3.7291834466465073`*^9, 3.729183459697401*^9}, 
   3.7292559361641417`*^9, 3.729552300379833*^9, 3.729557874992567*^9, 
   3.729629836791162*^9, 3.729634634527203*^9, 3.729642870835823*^9, 
   3.729642907315332*^9, 3.729643937395816*^9, 3.729647183669672*^9, 
   3.729683200518203*^9, 3.729778152836467*^9, 3.729779231029831*^9, 
   3.729779278929041*^9, 3.7298946991214314`*^9, 3.729896004754665*^9, 
   3.729896151488159*^9},ExpressionUUID->"b1bcc1a4-5ac7-4cb7-94d4-\
4276cdb1fbcd"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Faked Observations \[CapitalZeta]", "Subchapter",
 CellChangeTimes->{{3.727038130736038*^9, 3.727038133799975*^9}, 
   3.727038190200441*^9, {3.7280914789368753`*^9, 3.728091489257578*^9}},
 CellTags->"c:6",ExpressionUUID->"d543cb4f-56dc-41e2-9b9a-e595f99ddf99"],

Cell[TextData[{
 "Here we define a global variable, ",
 Cell[BoxData[
  FormBox["data", TraditionalForm]], "Code",ExpressionUUID->
  "b08739b2-ea21-42be-a02e-2062d457b83b"],
 ", to be used in later derivations and demonstrations:"
}], "Text",
 CellChangeTimes->{{3.729796582381321*^9, 
  3.729796618172481*^9}},ExpressionUUID->"00b3e53e-95b5-45e0-8e9c-\
e7a4e956d924"],

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
  3.727451399962222*^9}},ExpressionUUID->"70f226dc-2403-422b-80b0-\
330c3808ce1b"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{"data", ",", "noise\[Sigma]"}], "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"noise\[Sigma]", "=", "0.65"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"data", "=", 
   RowBox[{"fake", "[", 
    RowBox[{
    "nData", ",", "noise\[Sigma]", ",", "partials", ",", "groundTruth"}], 
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
  3.727451671078163*^9}, {3.7274720470935698`*^9, 3.727472053265984*^9}, {
  3.7280915253683*^9, 3.728091537656971*^9}, {3.729552257778557*^9, 
  3.729552307472777*^9}},ExpressionUUID->"0929a7fb-31dd-4475-b0d2-\
197746a7e8b6"],

Cell[BoxData[
 TagBox[
  RowBox[{"{", 
   RowBox[{
    RowBox[{"-", "1.8885370857483548`"}], ",", 
    RowBox[{"-", "0.374883765320909`"}], ",", 
    RowBox[{"-", "0.6459316372663111`"}], ",", 
    RowBox[{"-", "1.2026882605115103`"}], ",", 
    RowBox[{"\[LeftSkeleton]", "111", "\[RightSkeleton]"}], ",", 
    "0.353659915387855`", ",", "0.5239391557174188`", ",", 
    "2.200310824915457`", ",", "2.0420956153672765`"}], "}"}],
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
   3.7274855107778893`*^9, 3.727486308212657*^9, 3.727878577784017*^9, 
   3.727880787054256*^9, 3.7278811873704453`*^9, 3.7278813672409067`*^9, 
   3.7279153846882277`*^9, 3.727918036075748*^9, 3.727918094088941*^9, 
   3.727924197165626*^9, {3.7279277062395906`*^9, 3.727927731659636*^9}, 
   3.727967809786593*^9, 3.7279687327633533`*^9, 3.727969807759448*^9, 
   3.7279699546901617`*^9, 3.728044351191318*^9, 3.728046447285791*^9, 
   3.728066469199588*^9, 3.728068120401382*^9, 3.728083782912451*^9, 
   3.7280907408080997`*^9, 3.72809154205811*^9, 3.728169444492231*^9, 
   3.728169540095767*^9, 3.7281698222504396`*^9, 3.728169882302762*^9, 
   3.728252954702303*^9, 3.728946255311282*^9, 3.729022899574115*^9, {
   3.729119977772545*^9, 3.729119995034758*^9}, 3.729121071418002*^9, 
   3.72912111002391*^9, 3.7291723068108187`*^9, 3.7291756897299347`*^9, 
   3.729175743883057*^9, 3.7291834114467783`*^9, {3.72918344672998*^9, 
   3.729183459797777*^9}, 3.729255936257759*^9, {3.729552286826548*^9, 
   3.7295523004417877`*^9}, 3.72955787504913*^9, 3.729629836851104*^9, 
   3.72963463460248*^9, 3.729642870919276*^9, 3.729642907407959*^9, 
   3.7296439374687357`*^9, 3.7296471837506723`*^9, 3.72968320059123*^9, 
   3.729778152946784*^9, 3.729779231114318*^9, 3.729779279013398*^9, 
   3.7298946991874247`*^9, 3.729896004864834*^9, 
   3.7298961515821447`*^9},ExpressionUUID->"f96452d9-d7e6-45e2-8518-\
33d32596704e"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Wolfram Built-In", "Subchapter",
 CellChangeTimes->{{3.727039137746358*^9, 3.727039138418336*^9}, {
  3.7291811790576487`*^9, 3.729181183481278*^9}},
 CellTags->"c:7",ExpressionUUID->"7c21db9d-0a3c-4e16-8036-287d7221e622"],

Cell[TextData[{
 "The Wolfram built-in ",
 Cell[BoxData[
  FormBox["LinearModelFit", TraditionalForm]], "Code",ExpressionUUID->
  "c8409882-2bda-4f1b-a5f5-345712fdf085"],
 " computes an MLE (maximum-likelihood estimate) for ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "a072ad03-e1f6-4a62-8845-fb0fb07daace"],
 ". The estimated ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["m", "estimated"], TraditionalForm]],ExpressionUUID->
  "8bb6137a-c373-4e68-859f-b628ae16677d"],
 " and ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["b", "estimated"], TraditionalForm]],ExpressionUUID->
  "d7218397-fec7-4a19-834c-58cc47b9f6a1"],
 " are reasonably close to the ground truth ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"(", GridBox[{
       {"m"},
       {"b"}
      }], ")"}], "=", 
    FormBox[
     RowBox[{"(", "\[NoBreak]", GridBox[{
        {"0.5`"},
        {
         RowBox[{"-", "0.3333333333333333`"}]}
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
     TraditionalForm]}], TraditionalForm]],ExpressionUUID->
  "619be9a3-ed89-4377-b9a4-f9b3307ba376"],
 ". "
}], "Text",
 CellChangeTimes->{{3.727432553517992*^9, 3.727432621798977*^9}, {
  3.727472080939521*^9, 3.727472088160452*^9}, {3.728091559509233*^9, 
  3.7280915965871964`*^9}, {3.729181114250214*^9, 3.729181127378771*^9}, {
  3.729642997093185*^9, 3.7296430459691153`*^9}, {3.729796629339664*^9, 
  3.729796655666141*^9}, {3.729892439985653*^9, 
  3.729892439985759*^9}},ExpressionUUID->"bd354014-b75f-4675-8ab3-\
724f527b1594"],

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
       "}"}], "\[Transpose]"}], ",", "x", ",", "x"}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Normal", "[", "model", "]"}]}], "Input",
 CellChangeTimes->{{3.7270391419515553`*^9, 3.727039222672346*^9}, {
   3.727039589022585*^9, 3.727039634463044*^9}, {3.72703984614863*^9, 
   3.7270398612337418`*^9}, {3.727432525241551*^9, 3.727432532127486*^9}, 
   3.727445246314415*^9, {3.729022958695567*^9, 
   3.729022961245884*^9}},ExpressionUUID->"76e88281-275e-4110-b9de-\
c863257070c2"],

Cell[BoxData[
 RowBox[{
  RowBox[{"-", "0.3855034823605705`"}], "+", 
  RowBox[{"0.6019254636785574`", " ", "x"}]}]], "Output",
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
   3.727462600989726*^9, 3.7274721375146713`*^9, 3.727485510832881*^9, 
   3.7274863082710543`*^9, 3.727878577840499*^9, 3.727880787101037*^9, 
   3.727881187428447*^9, 3.7278813672674103`*^9, 3.727915384737116*^9, 
   3.72791803614151*^9, 3.7279180941213903`*^9, 3.727924197222649*^9, {
   3.727927706298745*^9, 3.7279277317186337`*^9}, 3.727967809847283*^9, 
   3.7279687328234253`*^9, 3.727969807818206*^9, 3.7279699547399473`*^9, 
   3.7280443512586803`*^9, 3.728046447345396*^9, 3.728066469257868*^9, 
   3.72806812045158*^9, 3.728083782977825*^9, 3.728090740871644*^9, 
   3.728169444560561*^9, 3.728169540157092*^9, 3.72816982231103*^9, 
   3.7281698823703403`*^9, 3.728252954766592*^9, 3.7289462553806963`*^9, 
   3.729022899597123*^9, 3.729022962429747*^9, {3.729119977839348*^9, 
   3.729119995092936*^9}, 3.729121071495359*^9, 3.729121110082161*^9, 
   3.729172306871163*^9, 3.729175689791526*^9, 3.729175746503436*^9, 
   3.729183411514368*^9, {3.729183446802239*^9, 3.729183459872917*^9}, 
   3.7292559363249063`*^9, 3.7295523004935513`*^9, 3.729557875098798*^9, 
   3.729629836899338*^9, 3.729634634660095*^9, 3.729642870980741*^9, 
   3.729642907467251*^9, 3.72964393753092*^9, 3.7296471838097754`*^9, 
   3.729683200649811*^9, 3.72977815300661*^9, 3.7297792311672363`*^9, 
   3.729779279076786*^9, 3.72989469924911*^9, 3.729896004921364*^9, 
   3.729896151643352*^9},ExpressionUUID->"55122cef-62a3-4c79-90d9-\
3bab49faeaff"]
}, Open  ]],

Cell["\<\
Un-comment the following line to see everything Wolfram has to say about this \
MLE (it\[CloseCurlyQuote]s a lot of data).\
\>", "Text",
 CellChangeTimes->{{3.727445705251766*^9, 3.727445735756525*^9}, {
   3.727446896680705*^9, 3.727446898174596*^9}, 3.727447110091947*^9, {
   3.728091613989747*^9, 
   3.7280916153070917`*^9}},ExpressionUUID->"361c3e32-0911-48e5-969d-\
f5beffe36997"],

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
  3.727454016578137*^9}},ExpressionUUID->"a6371160-8048-46ae-aa8e-\
bd8961e1a367"],

Cell["\<\
For purposes below, the most important attribute of the model is its \
covariance matrix. We come back to it below.\
\>", "Text",
 CellChangeTimes->{{3.72955741357407*^9, 
  3.7295574395717163`*^9}},ExpressionUUID->"3c5df78b-04eb-428e-b4d9-\
3c4d55925c73"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"model", "[", "\"\<CovarianceMatrix\>\"", "]"}], "//", 
  "MatrixForm"}]], "Input",
 CellChangeTimes->{{3.7295573787326307`*^9, 
  3.7295574025236588`*^9}},ExpressionUUID->"a269ae56-83b8-492b-9dbe-\
38b9fbc7dee0"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"0.0066731167409087655`", 
      RowBox[{"-", "0.002832474012328181`"}]},
     {
      RowBox[{"-", "0.002832474012328181`"}], "0.002832474012328181`"}
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
 CellChangeTimes->{{3.729557386643347*^9, 3.72955740355597*^9}, 
   3.729557875150962*^9, 3.729629836975811*^9, 3.729634634732983*^9, 
   3.729642871050211*^9, 3.729642907554695*^9, 3.729643937605584*^9, 
   3.729647183884037*^9, 3.729683200722887*^9, 3.729778153092148*^9, 
   3.729779231241169*^9, 3.729779279163685*^9, 3.729894699328005*^9, 
   3.729896005011405*^9, 
   3.7298961517319736`*^9},ExpressionUUID->"3e92a4c9-c090-47ae-87ad-\
2bfef954f258"]
}, Open  ]],

Cell[TextData[{
 "The plot shows that Wolfram does an acceptable job, for practical purposes, \
of estimating the parameters ",
 Cell[BoxData[
  FormBox["m", TraditionalForm]],ExpressionUUID->
  "957969ed-d6e9-4dae-9f5d-a59132086d64"],
 " and ",
 Cell[BoxData[
  FormBox["b", TraditionalForm]],ExpressionUUID->
  "c753b193-4efd-408f-83db-bd5ff456e748"],
 " that define the line. We have 119 data and two parameters to estimate, so \
over-fitting will not be an issue in this early example. We explore \
over-fitting at length below."
}], "Text",
 CellChangeTimes->{{3.72748603072836*^9, 3.7274860648301*^9}, {
  3.7291812022277317`*^9, 3.7291812668515997`*^9}, {3.729643073881525*^9, 
  3.729643087239958*^9}},ExpressionUUID->"cc694cdf-4bf6-46fe-90f0-\
a64592f7d1d2"],

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
        RowBox[{"m", " ", "x"}], "+", "b"}], ",", 
       RowBox[{"model", "[", "x", "]"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"x", ",", "min", ",", "max"}], "}"}]}], "]"}]}], "]"}]], "Input",\

 CellChangeTimes->{{3.727039646243634*^9, 3.7270396697516117`*^9}, {
   3.727039719966466*^9, 3.727039823407961*^9}, 3.727447260921829*^9, {
   3.727472117984476*^9, 3.72747212110266*^9}, {3.7274729782058973`*^9, 
   3.727472978941469*^9}, {3.729022972254067*^9, 3.729022988249905*^9}, 
   3.729558657302623*^9},ExpressionUUID->"8ce751c4-9067-4ce1-9f23-\
7acdbaf97716"],

Cell[BoxData[
 GraphicsBox[{{{}, {{}, 
     {RGBColor[0.368417, 0.506779, 0.709798], PointSize[0.009166666666666668],
       AbsoluteThickness[1.6], PointBox[CompressedData["
1:eJw1VQk01HkcH2Mcm9pK6ZWXltauDqWVJyv5/thQ2WR7RYeNWNVTFhWhdAjZ
jnVkZVuFTlQboi3FV7SUsK7kjHElzDRjYoxzZ37/v3lv3rx5v//3+Fy/v567
z1ZPLofDOSb/Kn6ZjwhtlrxOO7xmAqMeqGs79AoxKGsoaP7EO1y0e7ZJYq0A
dzmtqgm814l/K47z+/Ei/4aGqaUE1z1efMAsrQ+rjR+sntbYj2Uey0MjLvfi
nSSVDTX2vAJaHvIRdQ/5cTKtpNibbyGv6MECk3dc9bnDGHzIptJ36wdcssM+
aV6BCGl7i2603PYur/x1OSaUOPFmGHQh3HHkTyYK0MDfVb5SJ57Mc7E/2C1D
On60Hd0sjUo87g6hrbybtIuPDg1PN52aLsbakCD5hDbU1v/OxjZtEF8p2vm3
Ys/7F+2BCQPYnallVbSxBW3NlyqdPleLilPXRU14OEVFWuXdBbT9QD1qP/KU
PNv8Eq3lD18pqUOhzZf1z5QG0Y0hCE8lztaVqdfgScU432p0l/F151lyChKZ
BbA8IzX9L69mOKpY36QM6z6axxT312AGHV+Cwh3V0ZhTi6I3CgKLcO8+beWw
O82wgy6Uj+/vV5oHZ71CCi8zB0nGsbk8zUsQnWsklywdHYwcK9NzpcihBMXg
+ZCr0iehbcD+B2t1WaH4cx8mM89Djlpf+zq/yql+YFwcd/O2ZAIdmXnQvcJ2
3trtuVP7QKXV3VfzOwqB3Rf+XP1iSG/LBwxk8ICPrcMI37kZWLyQVaVlJ9ja
iCcYPsA9pKth0e4qYPmC3JXxznqzupEwfEL8WLWm5F4X6jN8w+kVK13v/eQy
pQccinNI8G16g52MXlAs0fcslRUBqydIU50jjbubgNUbHJVPefRlBU75AX6P
L1+dezMXWL/ABi3lhSX7/8MljJ8gInLcLE5JCKzf4KqtxkX/LaXA+hF2317f
kDcsAtavkG3tPOPoiV5g/QyC8ocW/75pBBfG7+Bi/OqaT90nYPMACVVh0mlJ
vWDB5AXMd+0Jt5vBBzZPsEMzeuW7lfXA5g2StffE+MY2QTSTR5hzdqbx+vK3
wOYVaj8Y2t0PbkPK1nkRiDJ5O+eHPwUqp5YYxCeTU7/Z1gLpiuNkMZT4Lzi6
nd8B7beEckUHYG7/x9Ic536g8B4PQG91tZ5NmhBouZUEfvsxYJllQBmcT+bL
KySQNV4dsCaoCV4q5HL6DAtSkpaVCqUwpmjP/wz1eVnhXKkATKgBBiE5U1NL
5+EFoHRJB8GtWBhnwREjHR86BBMxB6fvNRLA+ysKwqVQa/r07ZuoTpinUPeK
FJYV2nlruI8DXW/xMLy2jrxeSEQQcVlh4GHgKxcEDorrkNJvJoMMwWbvDN0q
GFasXySDA7n1bp9yUmEVvdBGID9uySj3eB8w9hoBb7s6Xa0HNUDheYyCzx9e
6DVHBvUU8CjMWlUapfM8HTUpoDE4wE07cR0KcJMCPm8cbP7xMqiIbYdQutA4
OC/euv+23SDQeGlPwEwHT9m55yKg9NyagHwhntBpFYMhLZiEtRcMA7xOi+AX
hT1yJyG8Q+/JoY1NLF4OMTXzTDgT1s76i0NypPFZjZViFj+HpH6VGnKkYgS+
poA45JHx6PwYOU6kfCiRbzXV7PPv9wFz/yqR7GMabWXuQqDyFimRwl8FHuo/
iCCOLswlR9yLn7vpt7B8ccnFt6bGET3trH+5pPbepOuttBZk+OOSgdgZkdey
JMDkU5kEZl9yX5oigBTKpzKpUNfgc/T6gHk/KJMNO78YGbs+Cg2UX2USu9Om
uH91O9L4mfCIw+wtfmZGPUDXDeKR5bVHfHTPDLD54JHt+3ijurFSYPhXIbZ5
flEDlhPA3N8qZODG8U+tHSOsHiok2CnHvCNvks2TCjmb3WwYcrkHnlF9VEm3
Xk7hChgGZwpAlZQl6MQdTK4DCdVLlRxQMfW1j/8MzPtQlXB5rWEBe9uQymWk
RtZXJBn/fKOOvX/UiEGFy/SFL9tYPdVInGtllMVVJcLkVZ3c9W/83tSJQ/4H
tNvBAw==
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
      Annotation[#, "Charting`Private`Tag$2294#1"]& ], 
     TagBox[
      {RGBColor[0.880722, 0.611041, 0.142051], AbsoluteThickness[1.6], 
       Opacity[1.], LineBox[CompressedData["
1:eJwB4QQe+yFib1JlAgAAAE0AAAACAAAAXH4s1P//779nRWp8BJnvv97yRxDz
9e+/OPCD3/eS779gZ2NM5uvvvwqbnULrjO+/ZVCaxMzX77+t8NAI0oDvv24i
CLWZr++/9Js3lZ9o77+BxuOVM1/vv4HyBK46OO+/pg6bV2e+7r+cn5/fcNfu
v/CeCdvOfO2/0fnUQt0V7r+qqRfUg8Pqvx5GA1Ylcuy/PYDfKG446L9ygYrN
Perqv27XiAseuuW/FuQ4TAZq6b/FGGPgswXjv57eqhc+yee/9SX3EH9/4L8s
yHVHRkTmv5c6eGdghtu/nkkExL2e5L9/KsXITSfWv1/yuUflAOO/GbKF4aUk
0b8nisgv3X7hv/8bUL2Ta8e/pXM1yYi4379fBvhMYo26vwixi/v3qty/rWZv
OSanmr8LPTA8x6zZv6wDcj0/1a0/1vhbFnVt1r9Iv//2robBP62SObnDZdO/
C1XfVXZwzD9MXJ718BzQvyx0nL6Tk9M/FumigPzGyb8gptWagZLYP6zVbKdY
w8O/yAOtkqP93T+kQ4oC5Hq6v99kiGkthuE/OKgEsjObrL+0XYkXo0PkP4A7
clmhvHG/69WoN1P05j9YpDXpCrGnP0mCDvzNduk/5E8F3FHutz+BREPOYi/s
PzyHqe5RhMI/4Dq+RMK57j9wquxdOaLIP1HYqxaum/A/ZDCTsGChzj8fHuAR
iPXxP2arFWhlkdI/AH43X0c48z+K4C+veZrVP85odrMTlvQ/6OXCXK/k2D9O
k8RAfe31P6icB/yEH9w/4dc1IMwt9z9cdZrSuSLfP2GnjgYoifg/Iw/TB4gz
4T/0kAo/ac35P5L0/8HiueI/ObqVsEcL+z+ysgV1jTjkP2puCCkzZPw/7thH
28jX5T+vPJ7zA6b9PyIQMd0zW+c/4ZUbxeEC/z90r1aSL//oP5MEXnRSJABA
wF8j41qH6j8O3rWiAsQAQLroyCzWB+w/AH2BVDlxAUDU2aop4qjtP/uoXq/i
EgJA5Nszwh0u7z9tmq+NEsICQAmj/Ab1afA/uCuICBFuA0B4xEspAznxPwxK
ciyCDgRAZG5uGSn68T/XLdDTebwEQF5ML2OXy/I/q54/JOReBUDVssN6HY/z
P1ivNhEd/gVApIXEjstO9D97haGB3KoGQICMY/zBHvU/qOgdmw5MB0DaG9Y3
0OD1P4SdhWDeTgdArooZtzLk9T9gUu0lrlEHQIP5XDaV5/U/F7y8sE1XB0As
1+M0Wu71P4aPW8aMYgdAfpLxMeT79T9kNpnxCnkHQCMJDSz4FvY/IIQUSAem
B0Bt9kMgIE32P/w4fA3XqAdAQmWHn4JQ9j/Y7ePSpqsHQBfUyh7lU/Y/j1ez
XUaxB0DAsVEdqlr2P/4qUnOFvAdAEm1fGjRo9j/c0Y+eA9MHQLfjehRIg/Y/
uIb3Y9PVB0CMUr6Tqob2P5Q7Xymj2AdAYcEBEw2K9j9LpS60Qt4HQAmfiBHS
kPY/unjNyYHpB0BcWpYOXJ72P5YtNY9R7AdAMcnZjb6h9j9x4pxUIe8HQAQ4
HQ0hpfY/KExs38D0B0CtFaQL5qv2PwQB1KSQ9wdAgoTnikiv9j/gtTtqYPoH
QFfzKgqrsvY/vGqjLzD9B0AsYm6JDbb2P5cfC/X//wdA/9CxCHC59j8aIXwF

        "]]},
      Annotation[#, "Charting`Private`Tag$2294#2"]& ]}, {}, {}}},
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
  PlotRange->{{-1., 3.}, {-2.5370240809169955`, 2.200310824915457}},
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
   3.727485511026442*^9, 3.7274863084589243`*^9, 3.727878578108341*^9, 
   3.727880787187166*^9, 3.727881187660624*^9, 3.727881367362421*^9, 
   3.727915384979436*^9, 3.727918036407303*^9, 3.727918094232634*^9, 
   3.727924197467864*^9, {3.7279277065514917`*^9, 3.72792773181036*^9}, 
   3.7279678100081873`*^9, 3.727968732916506*^9, 3.727969807912593*^9, 
   3.727969954824*^9, 3.728044351393855*^9, 3.7280464474397182`*^9, 
   3.728066469373081*^9, 3.728068120547882*^9, 3.728083783120768*^9, 
   3.728090741113459*^9, 3.72816944482609*^9, 3.728169540411261*^9, 
   3.728169822560478*^9, 3.728169882589735*^9, 3.728252955037623*^9, 
   3.7289462555001717`*^9, 3.729022899694229*^9, {3.7290229785172358`*^9, 
   3.729022989025024*^9}, {3.7291199780929327`*^9, 3.72911999521071*^9}, 
   3.7291210716202803`*^9, 3.729121110195902*^9, 3.729172306990698*^9, 
   3.729175690032875*^9, 3.729175752112059*^9, 3.729183411778121*^9, {
   3.729183447029324*^9, 3.729183459995894*^9}, 3.729255936469942*^9, 
   3.729552300734869*^9, 3.7295578752136106`*^9, 3.729629837059063*^9, 
   3.729634634939146*^9, 3.729642871231386*^9, 3.729642907748444*^9, 
   3.729643937794228*^9, 3.7296471840945873`*^9, 3.7296832009361258`*^9, 
   3.729778153343004*^9, 3.729779231469899*^9, 3.729779279378066*^9, 
   3.729894699394485*^9, 3.729896005230455*^9, 
   3.729896151919482*^9},ExpressionUUID->"da042fbb-b4a7-4659-b742-\
e335c2ce7ca1"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Normal Equations ", "Subchapter",
 CellChangeTimes->{{3.727038154048767*^9, 3.7270381788082533`*^9}, {
  3.72737126177953*^9, 3.727371269395361*^9}, {3.7273713004742193`*^9, 
  3.727371301473422*^9}, {3.727432388690963*^9, 3.727432389111678*^9}},
 CellTags->"c:8",ExpressionUUID->"9e404945-3a18-44e2-aeb1-ec425597d11f"],

Cell[TextData[{
 "Solve equation 1 for a value of ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "e1070982-4510-452d-9104-4027b4282bf6"],
 " that minimizes sum-squared error ",
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
 ". That is the same as maximizing the likelihood of the data given the \
parameters, ",
 Cell[BoxData[
  FormBox[
   RowBox[{"p", "\[ThinSpace]", "(", "\[ThinSpace]", 
    RowBox[{"Z", "\[VerticalSeparator]", "\[CapitalXi]"}], "\[ThinSpace]", 
    ")"}], TraditionalForm]],ExpressionUUID->
  "9c939515-2fd8-483c-8d91-92bc6c692f12"],
 ". Because the noise ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"\[ScriptCapitalN]", "(", 
     RowBox[{"0", ",", "\[Sigma]"}], ")"}], " "}], TraditionalForm]],
  ExpressionUUID->"d2ef2ed6-3502-41a9-ab64-83e47fa693fe"],
 "has zero mean, The solution turns out to be exactly what one would get from \
naive algebra:  ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}], TraditionalForm]],
  ExpressionUUID->"8524cb7a-422e-4376-9160-8b30cfd59b34"],
 " is square; when it is invertible,"
}], "Text",
 CellChangeTimes->{{3.7274327843718157`*^9, 3.7274328812568607`*^9}, {
   3.7274329695492764`*^9, 3.727432987909341*^9}, {3.7274405929522963`*^9, 
   3.727440597776662*^9}, {3.7274408305087957`*^9, 3.727440834532775*^9}, {
   3.727441137039894*^9, 3.7274412589545507`*^9}, {3.727441298555641*^9, 
   3.7274413240290527`*^9}, {3.727443711138123*^9, 3.727443712008112*^9}, 
   3.727443932952423*^9, {3.7274449899160423`*^9, 3.727444993644582*^9}, {
   3.7274721541913548`*^9, 3.727472171381256*^9}, {3.728091667557364*^9, 
   3.728091738028015*^9}, {3.729163097998804*^9, 3.729163154268798*^9}, {
   3.7291813681246843`*^9, 3.729181394329205*^9}, {3.729796702007291*^9, 
   3.729796706164723*^9}},ExpressionUUID->"4e07dc3c-bfe5-4ba2-a5fc-\
b9cd0f13e220"],

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
   3.727445003473629*^9},ExpressionUUID->"b895f84f-c47c-4a90-a492-\
0e50bb672b17"],

Cell["\<\
That gives numerically the same answer as Wolfram\[CloseCurlyQuote]s built-in:\
\>", "Text",
 CellChangeTimes->{{3.72747218573221*^9, 3.727472199188305*^9}, {
  3.7280917625845823`*^9, 3.728091764046361*^9}, {3.729181412765233*^9, 
  3.729181414139698*^9}},ExpressionUUID->"b3fba6d0-26c1-42c1-a388-\
b3e7d55c48ff"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"Inverse", "[", 
   RowBox[{
    RowBox[{"partials", "\[Transpose]"}], ".", "partials"}], "]"}], ".", 
  RowBox[{"partials", "\[Transpose]"}], ".", "data"}]], "Input",
 CellChangeTimes->{{3.727039915051565*^9, 3.727039947873397*^9}, {
  3.7274446395823927`*^9, 
  3.727444668828559*^9}},ExpressionUUID->"133ad946-91dc-4f78-a345-\
ce69827bf5cb"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.601925463678557`", ",", 
   RowBox[{"-", "0.38550348236057014`"}]}], "}"}]], "Output",
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
   3.7274855110572844`*^9, 3.727486308524558*^9, 3.727878578139612*^9, 
   3.727880787216714*^9, 3.727881187690591*^9, 3.727881367391988*^9, 
   3.727915385038457*^9, 3.727918036443694*^9, 3.727918094268628*^9, 
   3.727924197544126*^9, {3.727927706619681*^9, 3.727927731843884*^9}, 
   3.727967810043667*^9, 3.727968732947627*^9, 3.727969807968458*^9, 
   3.72796995487074*^9, 3.728044351457707*^9, 3.728046447476817*^9, 
   3.7280664694244013`*^9, 3.7280681205745*^9, 3.728083783151114*^9, 
   3.7280907411475573`*^9, 3.728169444868794*^9, 3.7281695404344788`*^9, 
   3.7281698225833893`*^9, 3.728169882612453*^9, 3.728252955102865*^9, 
   3.7289462555432*^9, 3.729022899709242*^9, {3.729119978129813*^9, 
   3.7291199952297564`*^9}, 3.7291210716763897`*^9, 3.729121110230036*^9, 
   3.729172307024598*^9, 3.729175690092051*^9, 3.729175756864266*^9, 
   3.729183411801414*^9, {3.7291834470773993`*^9, 3.7291834600163918`*^9}, 
   3.729255936489287*^9, 3.729552300792214*^9, 3.7295573170951357`*^9, 
   3.729557875240993*^9, 3.729629837077847*^9, 3.729634634968029*^9, 
   3.729642871251685*^9, 3.729642907795554*^9, 3.729643937848379*^9, 
   3.729647184159255*^9, 3.729683200973136*^9, 3.729778153407301*^9, 
   3.729779231531921*^9, 3.72977927943953*^9, 3.7298946994529676`*^9, 
   3.729896005268653*^9, 
   3.729896151957491*^9},ExpressionUUID->"dc9472d4-be58-4364-8d1f-\
c5ca7ba70245"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Moore-Penrose PseudoInverse", "Subsection",
 CellChangeTimes->{{3.729181426526401*^9, 
  3.729181437678577*^9}},ExpressionUUID->"76033957-f3cc-4406-ae95-\
a9107e9b01e9"],

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
 ". Wolfram has a built-in for it. We get exactly the same answer as above:"
}], "Text",
 CellChangeTimes->{{3.727433101666657*^9, 3.727433150009388*^9}, {
  3.7280917743950377`*^9, 
  3.728091785282933*^9}},ExpressionUUID->"a17e8e76-4c4a-456e-a800-\
99230c07f26c"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{
   StyleBox["PseudoInverse",
    Background->RGBColor[0.87, 0.94, 1]], "[", "partials", "]"}], ".", 
  "data"}]], "Input",
 CellChangeTimes->{{3.7273712853724957`*^9, 
  3.727371293874542*^9}},ExpressionUUID->"01d5013c-6e52-4ad2-83e4-\
c664df66f030"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.6019254636785569`", ",", 
   RowBox[{"-", "0.3855034823605701`"}]}], "}"}]], "Output",
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
   3.7274855111041203`*^9, 3.7274863085745363`*^9, 3.727878578191661*^9, 
   3.727880787262898*^9, 3.7278811877447987`*^9, 3.7278813674336567`*^9, 
   3.727915385085929*^9, 3.7279180365110283`*^9, 3.7279180943317223`*^9, 
   3.727924197609661*^9, {3.727927706685451*^9, 3.727927731906424*^9}, 
   3.7279678100965147`*^9, 3.727968733006201*^9, 3.727969808022567*^9, 
   3.727969954920972*^9, 3.728044351520423*^9, 3.7280464475530863`*^9, 
   3.72806646947083*^9, 3.7280681206141787`*^9, 3.728083783213682*^9, 
   3.728090741206085*^9, 3.7281694449283533`*^9, 3.72816954049078*^9, 
   3.728169822646145*^9, 3.7281698826713457`*^9, 3.728252955169929*^9, 
   3.728946255597731*^9, 3.729022899770589*^9, {3.729119978187595*^9, 
   3.7291199952927637`*^9}, 3.729121071744602*^9, 3.729121110282917*^9, 
   3.729172307089141*^9, 3.72917569014242*^9, 3.729175758767949*^9, 
   3.7291834118647947`*^9, {3.729183447136406*^9, 3.729183460090003*^9}, 
   3.7292559365559196`*^9, 3.729552300842052*^9, 3.729557875298991*^9, 
   3.7296298371310453`*^9, 3.7296346349947653`*^9, 3.729642871293008*^9, 
   3.729642907867766*^9, 3.729643937910441*^9, 3.729647184209032*^9, 
   3.729683201016131*^9, 3.729778153456196*^9, 3.729779231587756*^9, 
   3.7297792795058413`*^9, 3.7298946994996367`*^9, 3.729896005342469*^9, 
   3.729896152024362*^9},ExpressionUUID->"f6eec804-86f4-4a9b-bed3-\
70570f31a313"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Avoiding Inversion", "Subsection",
 CellChangeTimes->{{3.7291814457025623`*^9, 
  3.729181460660458*^9}},ExpressionUUID->"e51e3bb5-9f1d-461b-82b9-\
a629644e78d3"],

Cell[TextData[{
 "Avoid the inverse via ",
 Cell[BoxData[
  FormBox["LinearSolve", TraditionalForm]], "Code",ExpressionUUID->
  "37533133-5282-4799-abf2-0ebc04a81068"],
 ". We have more to say about avoiding inverses below."
}], "Text",
 CellChangeTimes->{{3.729163192693755*^9, 3.729163205069344*^9}, {
  3.729163249751759*^9, 3.729163251892954*^9}, {3.729181463137731*^9, 
  3.7291814787717247`*^9}},ExpressionUUID->"9f17f33b-f15e-49bc-91f5-\
a3a049be2bc7"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"LinearSolve", "[", 
   RowBox[{
    RowBox[{
     RowBox[{"partials", "\[Transpose]"}], ".", "partials"}], ",", 
    RowBox[{"partials", "\[Transpose]"}]}], "]"}], ".", "data"}]], "Input",
 CellChangeTimes->{{3.7291632280602016`*^9, 
  3.72916324189844*^9}},ExpressionUUID->"1ae0bc2a-89a7-4487-8b0b-\
38a63c9f9d50"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.6019254636785569`", ",", 
   RowBox[{"-", "0.38550348236057014`"}]}], "}"}]], "Output",
 CellChangeTimes->{
  3.729163242164153*^9, 3.729172307155374*^9, 3.729175690191784*^9, 
   3.729175760404626*^9, 3.729183411932454*^9, {3.729183447202159*^9, 
   3.7291834601576347`*^9}, 3.729255936622262*^9, 3.729552300896743*^9, 
   3.729557875348524*^9, 3.729629837180914*^9, 3.7296346350478573`*^9, 
   3.729642871344585*^9, 3.7296429079352827`*^9, 3.729643937976184*^9, 
   3.729647184259219*^9, 3.729683201066106*^9, 3.7297781535055656`*^9, 
   3.7297792316516247`*^9, 3.729779279556422*^9, 3.729894699550214*^9, 
   3.7298960054089727`*^9, 
   3.729896152088458*^9},ExpressionUUID->"9792fc6e-42ac-4882-8686-\
03b40a96c48a"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Don\[CloseCurlyQuote]t Use the Normal Equations", "Subsection",
 CellChangeTimes->{{3.729023046617814*^9, 
  3.729023056448161*^9}},ExpressionUUID->"a03000c1-fcb9-4707-9571-\
4867f157d100"],

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
 " is a nasty computation: in memory usage (big matrices), in time (matrix \
multiplication), and in numerical risk (inverse). How to avoid these hazards? \
Find a recurrence relation."
}], "Text",
 CellChangeTimes->{{3.727472215578988*^9, 3.727472331662753*^9}, {
   3.727472374436943*^9, 3.727472378052897*^9}, {3.727475400731699*^9, 
   3.727475478400813*^9}, {3.727486165404456*^9, 3.727486166210432*^9}, {
   3.7278779774894447`*^9, 3.7278779789823847`*^9}, {3.7279659504745617`*^9, 
   3.7279659782582006`*^9}, {3.729023065666107*^9, 3.7290230711752653`*^9}, 
   3.7291631748405437`*^9, {3.729181515226803*^9, 3.729181589797641*^9}, {
   3.729643138837819*^9, 3.729643155547853*^9}, {3.7297967431907587`*^9, 
   3.729796744103146*^9}},ExpressionUUID->"fe3fcfea-7630-4754-b191-\
17a984a29511"]
}, Open  ]]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Recurrence", "Chapter",
 CellChangeTimes->{{3.7270402093685093`*^9, 3.727040216990353*^9}, {
  3.72744887906024*^9, 3.727448879173937*^9}},
 CellTags->"c:9",ExpressionUUID->"2a93cd2e-fae9-4448-99ff-94f55680bddf"],

Cell[TextData[{
 Cell[BoxData[
  FormBox["Fold", TraditionalForm]], "Code",ExpressionUUID->
  "9d09a6fc-b121-455e-a488-8b5ba33270cc"],
 " this recurrence over ",
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
  3.727472404763022*^9}, {3.727475498217351*^9, 3.727475507311516*^9}, {
  3.728949021675457*^9, 3.728949025315466*^9}, {3.7296432127240763`*^9, 
  3.729643225187282*^9}},ExpressionUUID->"098b2a28-cc9e-454c-aaa3-\
8401cdd7dc9b"],

Cell[BoxData[{
 FormBox[
  RowBox[{"\[Xi]", "\[LeftArrow]", 
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
      RowBox[{"\[CapitalLambda]", "\[CenterDot]", "\[Xi]"}]}], ")"}]}]}], 
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
  3.7274435995641823`*^9}, {3.727443898455867*^9, 3.727443902554981*^9}, {
  3.7289483265782537`*^9, 
  3.728948362573649*^9}},ExpressionUUID->"8c9b8880-133c-4ffa-b013-\
ff69aead1159"],

Cell["where", "Text",
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
   3.7274743397668333`*^9}, {3.727475519390863*^9, 3.727475555533572*^9}, {
   3.728948365542074*^9, 3.728948365542119*^9}, 3.728948905148108*^9, {
   3.728948947025461*^9, 3.728948959432898*^9}, {3.729163268464349*^9, 
   3.729163279091194*^9}},ExpressionUUID->"93e3d34c-92db-4ddf-8583-\
f7d39262a44e"],

Cell[CellGroupData[{

Cell[TextData[{
 Cell[BoxData[
  FormBox["\[Xi]", TraditionalForm]],ExpressionUUID->
  "ca15d208-e524-41c0-86fa-973d1991e372"],
 " is the current estimate of ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "7e9f4450-1588-4d24-a011-c32f0e00a6ac"]
}], "Item",
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
   3.7274743397668333`*^9}, {3.727475519390863*^9, 3.727475555533572*^9}, {
   3.728948365542074*^9, 3.728948365542119*^9}, 3.728948905148108*^9, {
   3.728948947025461*^9, 3.728948959432898*^9}, {3.729163268464349*^9, 
   3.7291632861423903`*^9}},ExpressionUUID->"899961b0-dc4b-4a8d-a91a-\
7838306ffeb7"],

Cell[TextData[{
 Cell[BoxData[
  FormBox["a", TraditionalForm]],ExpressionUUID->
  "a23b953c-cf49-41f8-8447-fbb397bff922"],
 " and ",
 Cell[BoxData[
  FormBox["\[Zeta]", TraditionalForm]],ExpressionUUID->
  "6d94e1b0-0bbb-42e2-906c-580263360fee"],
 " are matched rows of ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "9a4623dd-e230-41f2-9800-86cd6f5d5c72"],
 " and ",
 Cell[BoxData[
  FormBox["\[CapitalZeta]", TraditionalForm]],ExpressionUUID->
  "eb9de015-f9e0-4d0b-a5ef-5bef8a6f08fe"]
}], "Item",
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
   3.7274743397668333`*^9}, {3.727475519390863*^9, 3.727475555533572*^9}, {
   3.728948365542074*^9, 3.728948365542119*^9}, 3.728948905148108*^9, {
   3.728948947025461*^9, 3.728948959432898*^9}, {3.729163268464349*^9, 
   3.72916328446143*^9}},ExpressionUUID->"f2dff4c4-6938-4386-b5b0-\
b9bcc3219bab"],

Cell[TextData[{
 Cell[BoxData[
  FormBox["\[CapitalLambda]", TraditionalForm]],ExpressionUUID->
  "40f23918-c675-4b98-8edb-bb01eadd40cd"],
 " accumulates ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}], TraditionalForm]],
  ExpressionUUID->"dadb94d5-443c-474e-b745-213b7ceefa94"],
 ". "
}], "Item",
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
   3.7274743397668333`*^9}, {3.727475519390863*^9, 3.727475555533572*^9}, {
   3.728948365542074*^9, 3.728948365542119*^9}, 3.728948905148108*^9, {
   3.728948947025461*^9, 3.728948959432898*^9}, {3.729163268464349*^9, 
   3.729163280317943*^9}},ExpressionUUID->"66c566e3-4f1a-4ccf-bc11-\
2b5cc669341b"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Derivation Sketch", "Subsection",
 CellChangeTimes->{{3.729181602847373*^9, 
  3.7291816059298487`*^9}},ExpressionUUID->"c1da9886-0928-41f5-bdfc-\
310d1668dba2"],

Cell["\<\
Derive the recurrence as follows: Treat the estimate-so-far, \
\>", "Text",
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
   3.7274748698817673`*^9}, {3.727475577962327*^9, 3.7274756335231857`*^9}, {
   3.7278780344572*^9, 3.727878045059162*^9}, 3.727966016823514*^9, {
   3.7279661542692223`*^9, 3.727966155428653*^9}, {3.727966432921638*^9, 
   3.7279665200041933`*^9}, {3.729163880807461*^9, 3.729163884901907*^9}, 
   3.7291816149796658`*^9},ExpressionUUID->"86467c14-4fa6-426a-86c5-\
cfa931632401"],

Cell[BoxData[
 FormBox[
  RowBox[{
   SubscriptBox["\[Xi]", 
    RowBox[{"so", "-", "far"}]], 
   OverscriptBox["=", "def"], 
   RowBox[{
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{
       RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}], ")"}], 
     RowBox[{"-", "1"}]], "\[CenterDot]", 
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", 
    SubscriptBox["\[CapitalZeta]", 
     RowBox[{"so", "-", "far"}]]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
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
   3.7274748698817673`*^9}, {3.727475577962327*^9, 3.7274756335231857`*^9}, {
   3.7278780344572*^9, 3.727878045059162*^9}, 3.727966016823514*^9, {
   3.7279661542692223`*^9, 3.727966155428653*^9}, {3.727966432921638*^9, 
   3.727966534440386*^9}, 3.728948369963612*^9, {3.729163903631165*^9, 
   3.7291639050399637`*^9}},ExpressionUUID->"f1279179-caa6-4e3b-817d-\
316c8cd857bf"],

Cell["as just one more observation with information matrix ", "Text",
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
   3.7274748698817673`*^9}, {3.727475577962327*^9, 3.7274756335231857`*^9}, {
   3.7278780344572*^9, 3.727878045059162*^9}, 3.727966016823514*^9, {
   3.7279661542692223`*^9, 3.727966155428653*^9}, {3.727966432921638*^9, 
   3.7279665258422337`*^9}, {3.728091815451824*^9, 3.728091821154443*^9}, 
   3.729023129658637*^9, {3.729643258643651*^9, 
   3.729643268273799*^9}},ExpressionUUID->"8af654ba-7edd-4480-97af-\
b1cff2d92cc2"],

Cell[BoxData[
 FormBox[
  RowBox[{"\[CapitalLambda]", "=", 
   RowBox[{
    RowBox[{
     SubscriptBox["A", 
      RowBox[{"so", "-", "far"}]], "\[Transpose]"}], "\[CenterDot]", 
    SubscriptBox["A", 
     RowBox[{"so", "-", "far"}]]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
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
   3.7274748698817673`*^9}, {3.727475577962327*^9, 3.7274756335231857`*^9}, {
   3.7278780344572*^9, 3.727878045059162*^9}, 3.727966016823514*^9, {
   3.7279661542692223`*^9, 3.727966155428653*^9}, {3.727966432921638*^9, 
   3.7279665258422337`*^9}, {3.728091815451824*^9, 3.728091821154443*^9}, {
   3.729023134641241*^9, 
   3.729023151157517*^9}},ExpressionUUID->"acbe4f6c-05ff-4b15-98b7-\
3273232da17b"],

Cell[TextData[{
 "The scalar ",
 StyleBox["performance",
  FontSlant->"Italic"],
 " or ",
 StyleBox["squared error",
  FontSlant->"Italic"],
 " of the estimate, so far, is"
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
   3.7274748698817673`*^9}, {3.727475577962327*^9, 3.7274756335231857`*^9}, {
   3.7278780344572*^9, 3.727878045059162*^9}, 3.727966016823514*^9, {
   3.7279661542692223`*^9, 3.727966155428653*^9}, {3.727966432921638*^9, 
   3.7279665258422337`*^9}, {3.728091815451824*^9, 
   3.728091821154443*^9}},ExpressionUUID->"fca13932-3ef6-481e-958c-\
4a5343bf7bb3"],

Cell[BoxData[
 FormBox[
  RowBox[{
   RowBox[{"J", "(", "\[Xi]", ")"}], "  ", "=", "  ", 
   RowBox[{
    RowBox[{
     RowBox[{
      RowBox[{"(", 
       RowBox[{
        SubscriptBox["\[CapitalZeta]", 
         RowBox[{"so", "-", "far"}]], "-", 
        RowBox[{
         SubscriptBox["A", 
          RowBox[{"so", "-", "far"}]], "\[CenterDot]", "\[Xi]"}]}], ")"}], 
      "\[Transpose]"}], "\[CenterDot]", 
     RowBox[{"(", 
      RowBox[{
       SubscriptBox["\[CapitalZeta]", 
        RowBox[{"so", "-", "far"}]], "-", 
       RowBox[{
        SubscriptBox["A", 
         RowBox[{"so", "-", "far"}]], "\[CenterDot]", "\[Xi]"}]}], ")"}]}], 
    "  ", "=", "  ", 
    RowBox[{
     RowBox[{
      RowBox[{"(", 
       RowBox[{"\[Xi]", "-", 
        SubscriptBox["\[Xi]", 
         RowBox[{"so", "-", "far"}]]}], ")"}], "\[Transpose]"}], 
     "\[CenterDot]", "\[CapitalLambda]", "\[CenterDot]", 
     RowBox[{"(", 
      RowBox[{"\[Xi]", "-", 
       SubscriptBox["\[Xi]", 
        RowBox[{"so", "-", "far"}]]}], ")"}]}]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
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
   3.7274748698817673`*^9}, {3.727475577962327*^9, 3.7274756335231857`*^9}, {
   3.7278780344572*^9, 3.727878045059162*^9}, {3.727966018203845*^9, 
   3.727966033785829*^9}, {3.727966098475103*^9, 3.7279661060884457`*^9}, {
   3.727966143206888*^9, 3.727966171156918*^9}, {3.7279662043636503`*^9, 
   3.727966213619438*^9}, {3.727966500313883*^9, 3.727966508975876*^9}, {
   3.7289483740986834`*^9, 3.728948376110648*^9}, {3.729023185419231*^9, 
   3.729023197425653*^9}},ExpressionUUID->"bbc114f3-8eed-40b1-8d10-\
6df69eae15a9"],

Cell[TextData[{
 "where ",
 Cell[BoxData[
  FormBox["\[Xi]", TraditionalForm]],ExpressionUUID->
  "dabda0f9-23ef-422e-9934-9019237efd52"],
 " is the unknown true parameter vector, ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalZeta]", 
    RowBox[{"so", "-", "far"}]], TraditionalForm]],ExpressionUUID->
  "684f54e2-bac0-42af-ad38-c1084a76ae15"],
 " is the column vector of all observations so-far, and ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalLambda]", "=", 
    RowBox[{
     RowBox[{
      SubscriptBox["A", 
       RowBox[{"so", "-", "far"}]], "\[Transpose]"}], "\[CenterDot]", 
     SubscriptBox["A", 
      RowBox[{"so", "-", "far"}]]}]}], TraditionalForm]],ExpressionUUID->
  "88dc0af1-fc18-4f07-8ec8-6c0cef0ffb99"],
 " . Adding a new observation, ",
 Cell[BoxData[
  FormBox["\[Zeta]", TraditionalForm]],ExpressionUUID->
  "f1276f71-b142-463f-9ad8-441cb4641cde"],
 " and its corresponding partial row covector ",
 Cell[BoxData[
  FormBox["a", TraditionalForm]],ExpressionUUID->
  "53497380-bd47-4d43-9f90-bf6637131b87"],
 ", increases the error ",
 Cell[BoxData[
  FormBox[
   RowBox[{"J", "(", "\[Xi]", ")"}], TraditionalForm]],ExpressionUUID->
  "f0d40762-7e96-4647-bdc6-37929527ce7b"],
 " by ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     RowBox[{"(", 
      RowBox[{"\[Zeta]", "-", 
       RowBox[{"a", "\[CenterDot]", "\[Xi]"}]}], ")"}], "\[Transpose]"}], 
    "\[CenterDot]", 
    RowBox[{"(", 
     RowBox[{"\[Zeta]", "-", 
      RowBox[{"a", "\[CenterDot]", "\[Xi]"}]}], ")"}]}], TraditionalForm]],
  ExpressionUUID->"9ec14d68-822d-4fce-a2c9-85c5fb353fe0"],
 ". Minimize the new total error with respect to ",
 Cell[BoxData[
  FormBox["\[Xi]", TraditionalForm]],ExpressionUUID->
  "96d4bc3a-53e7-428b-90b0-341c7f7145b3"],
 " to find the recurrence (exercise). \[FilledSquare]\n\nWe see that RLS \
perforce introduces an a-priori estimate ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Xi]", "0"], TraditionalForm]],ExpressionUUID->
  "a3077632-64d2-4dd3-97b2-78d84dfbc138"],
 " and its covariance, which is the inverse of the information matrix ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalLambda]", "0"], TraditionalForm]],ExpressionUUID->
  "09ea8b7f-b9f9-4c6c-bfbc-41c5d12b2f3e"],
 ". RLS is Bayesian by construction. We show below that, when renormalized \
with an a-priori covariance for the observations ",
 Cell[BoxData[
  FormBox["\[Zeta]", TraditionalForm]],ExpressionUUID->
  "27be3aff-c6a3-47ce-bd0d-45ac2c3f778a"],
 ", is theoretically equivalent to KAL and numerically equivalent to MAP. \
Proof of theoretical equivalence to MAP awaits future work."
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
   3.7274748698817673`*^9}, {3.727475577962327*^9, 3.7274756335231857`*^9}, {
   3.7278780344572*^9, 3.727878045059162*^9}, {3.727966018203845*^9, 
   3.727966022744957*^9}, {3.727966060652214*^9, 3.7279660814388037`*^9}, {
   3.727966122293776*^9, 3.727966131387149*^9}, {3.727966225308963*^9, 
   3.7279663153865147`*^9}, {3.72796657797972*^9, 3.7279665841676197`*^9}, {
   3.7290232013137093`*^9, 3.7290232220612392`*^9}, {3.729023260685502*^9, 
   3.729023282116056*^9}, 3.729119179347542*^9, {3.729163926938323*^9, 
   3.729163937969397*^9}, {3.729796790646969*^9, 3.72979688978856*^9}, {
   3.729796948582293*^9, 
   3.7297970605133133`*^9}},ExpressionUUID->"1fd06721-76a5-4cff-8458-\
cd6120f94b95"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Numerical Demonstration", "Subsection",
 CellChangeTimes->{{3.729181632544861*^9, 
  3.7291816365144157`*^9}},ExpressionUUID->"c6ec5072-c52b-499f-92b9-\
04355eb5c271"],

Cell[TextData[{
 "Bootstrap the recurrence with ad-hoc, a-priori values ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[Xi]", "0"], "=", 
    RowBox[{
     RowBox[{"(", GridBox[{
        {"0", "0"}
       }], ")"}], "\[Transpose]"}]}], TraditionalForm]],ExpressionUUID->
  "95c478f8-14cb-4c33-8055-6e0a24add5df"],
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
  "e79d365d-7771-4fa6-b690-5108edb5e668"],
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
   3.727475668421556*^9}, {3.727878056292527*^9, 3.7278781337625647`*^9}, {
   3.727966321732579*^9, 3.727966322440028*^9}, {3.727966591137054*^9, 
   3.727966628253271*^9}, {3.727966659401678*^9, 3.7279667699874363`*^9}, {
   3.728091848600717*^9, 3.728091848856659*^9}, {3.7289483786020403`*^9, 
   3.728948380301387*^9}, {3.729163955385151*^9, 3.729163980174839*^9}, {
   3.729643297812354*^9, 3.729643332107801*^9}, {3.7297970766391563`*^9, 
   3.7297970790208406`*^9}},ExpressionUUID->"e5a9ce1e-e00e-4f54-b85d-\
081e278adf90"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "update", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{"update", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"\[Xi]_", ",", "\[CapitalLambda]_"}], "}"}], ",", 
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
           RowBox[{"\[CapitalLambda]", ".", "\[Xi]"}]}], ")"}]}], ",", 
        "\[CapitalPi]"}], "}"}]}], "]"}]}], ";"}], 
  "\n"}], "\[IndentingNewLine]", 
 RowBox[{"MatrixForm", "/@", "\[IndentingNewLine]", 
  RowBox[{"(", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"(", GridBox[{
         {"mBar"},
         {"bBar"}
        }], ")"}], ",", "\[CapitalPi]"}], "}"}], "=", "\[IndentingNewLine]", 
    RowBox[{
     StyleBox["Fold",
      Background->RGBColor[1, 1, 0]], "[", 
     RowBox[{"update", ",", 
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
   3.7274725926081057`*^9}, {3.727473460371025*^9, 3.727473470385874*^9}, {
   3.727967024755598*^9, 3.7279670373987417`*^9}, 3.727967235445434*^9, {
   3.728948393392125*^9, 3.728948394937408*^9}, {3.729174117188925*^9, 
   3.729174123668703*^9}},ExpressionUUID->"8ffe4223-18a0-41f6-90b1-\
bb8a0ab30bb3"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.6019254575590622`"},
       {
        RowBox[{"-", "0.38550347300160165`"}]}
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
   3.727485511156743*^9, 3.727486308620812*^9, 3.727878578245182*^9, 
   3.727880787316627*^9, 3.727881187795374*^9, 3.72788136748368*^9, 
   3.7279153851348257`*^9, 3.727918036577284*^9, 3.7279180943800097`*^9, 
   3.727924197677032*^9, {3.727927706752205*^9, 3.727927731973207*^9}, 
   3.727967810149074*^9, 3.7279687330645437`*^9, 3.727969808085505*^9, 
   3.727969954973427*^9, 3.728044351569767*^9, 3.72804644760787*^9, 
   3.728066469525443*^9, 3.728068120668467*^9, 3.728083783280686*^9, 
   3.728090741272605*^9, 3.728169444994749*^9, 3.728169540556728*^9, 
   3.7281698227111*^9, 3.7281698827372704`*^9, 3.72825295523654*^9, 
   3.728946255665695*^9, 3.72902289982128*^9, {3.729119978255114*^9, 
   3.729119995360593*^9}, 3.7291210718114223`*^9, 3.729121110350542*^9, 
   3.7291723072225113`*^9, 3.729174119552033*^9, 3.729175690243061*^9, 
   3.729175768561432*^9, 3.729183411998878*^9, {3.729183447270482*^9, 
   3.7291834602232447`*^9}, 3.729255936689374*^9, 3.7295523012311068`*^9, 
   3.729557875800249*^9, 3.7296298378048058`*^9, 3.72963463574932*^9, 
   3.729642872038753*^9, 3.729642908638049*^9, 3.729643938027584*^9, 
   3.729647184308378*^9, 3.729683201116581*^9, 3.729778153560226*^9, 
   3.729779231717586*^9, 3.729779279623641*^9, 3.7298946995998697`*^9, 
   3.729896005475109*^9, 
   3.729896152143077*^9},ExpressionUUID->"e9e6e525-be23-44b2-8d6e-\
e32c219796fa"]
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
 " are, numerically, the same as we got from Wolfram\[CloseCurlyQuote]s \
built-in. For this example, the choice of ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Xi]", "0"], TraditionalForm]],ExpressionUUID->
  "7a752cc3-5524-4727-98d1-99e9e3e3c2f9"],
 " and ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalLambda]", "0"], TraditionalForm]],ExpressionUUID->
  "1040a599-038c-43fc-961e-93c029f458cd"],
 " had negligible effect. "
}], "Text",
 CellChangeTimes->{{3.727455669635949*^9, 3.727455714844105*^9}, {
   3.727456293561727*^9, 3.727456338621636*^9}, {3.727456381984915*^9, 
   3.727456493199937*^9}, {3.7274567040936413`*^9, 3.727456704869124*^9}, {
   3.727456739701139*^9, 3.72745677855204*^9}, {3.727472821547103*^9, 
   3.727472872838442*^9}, {3.7279667472572412`*^9, 3.72796679667021*^9}, {
   3.72894839921102*^9, 3.728948399211062*^9}, {3.729181651280912*^9, 
   3.729181667411229*^9}, {3.729643345781581*^9, 3.729643368401565*^9}, 
   3.729797100393939*^9},ExpressionUUID->"76e4229a-4899-4e33-9a86-\
b1ec1ee6041b"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Structural Notes", "Subsection",
 CellChangeTimes->{{3.729181678137927*^9, 
  3.729181681293388*^9}},ExpressionUUID->"a3d23e39-8323-41fa-be6c-\
d242fd29b800"],

Cell[TextData[{
 "The mappings of ",
 Cell[BoxData[
  FormBox["List", TraditionalForm]], "Code",ExpressionUUID->
  "370d0a8b-9c99-495c-8b0f-e38240d3f06a"],
 " over the data and partials convert them into column vectors. Wolfram \
built-ins and the normal equations, implicitly, treat one-dimensional lists \
as columns or rows as needed, then compute inner (dot) products as if the \
distinction did not matter. Python\[CloseCurlyQuote]s numpy has the same \
dubious feature. "
}], "Text",
 CellChangeTimes->{{3.727473114735071*^9, 3.727473196429072*^9}, 
   3.727475691841303*^9, {3.727879000591062*^9, 3.727879183230468*^9}, {
   3.727966817515026*^9, 3.727966992448154*^9}, {3.728091889609682*^9, 
   3.7280919220828123`*^9}, {3.729023350420405*^9, 3.729023392246647*^9}, {
   3.729119179359543*^9, 3.729119179371344*^9}, {3.7291640123507442`*^9, 
   3.7291640329396763`*^9}, {3.72916408829683*^9, 3.7291641046167603`*^9}, {
   3.729181694426371*^9, 
   3.729181705205323*^9}},ExpressionUUID->"43736b1c-cf5c-4aac-a310-\
90396ff4ff12"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Memory and Time Efficiency", "Subsection",
 CellChangeTimes->{{3.729181722918578*^9, 
  3.7291817314071093`*^9}},ExpressionUUID->"5e5972fa-092f-4c1c-aa76-\
6ecda346cfcd"],

Cell[TextData[{
 "The required memory for the recurrence is ",
 Cell[BoxData[
  FormBox[
   RowBox[{"O", "(", "\[CapitalMu]", ")"}], TraditionalForm]],ExpressionUUID->
  "a43af123-6e23-4747-99f5-4541967c6079"],
 ", where ",
 Cell[BoxData[
  FormBox["\[CapitalMu]", TraditionalForm]],ExpressionUUID->
  "554653cf-ce3e-4f63-b5d1-49baddb2469f"],
 " is the order of the model, the number of parameters to estimate, the \
length of ",
 Cell[BoxData[
  FormBox["\[CapitalXi]", TraditionalForm]],ExpressionUUID->
  "5cad892a-a66c-4479-a419-39792c33e9e0"],
 ", and the length of each row of ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "332e127a-feaa-4be6-a475-985ccedc0886"],
 ". There is no dependency at all on the number ",
 Cell[BoxData[
  FormBox["\[CapitalNu]", TraditionalForm]],ExpressionUUID->
  "70e72b1a-0126-4373-80a0-6d790e7d6cc8"],
 " of data items. Also, the recurrence accumulates data one observation at a \
time, and is thus ",
 Cell[BoxData[
  FormBox[
   RowBox[{"O", "(", "\[CapitalNu]", ")"}], TraditionalForm]],ExpressionUUID->
  "efd7941a-b9ef-460b-abc5-d458205967fa"],
 " in time. Contrast with the normal equations, which multiply at ",
 Cell[BoxData[
  FormBox[
   RowBox[{"~", 
    RowBox[{"O", "(", 
     SuperscriptBox["\[CapitalNu]", "3"], ")"}]}], TraditionalForm]],
  ExpressionUUID->"d0c9ea26-5793-4a2e-88e5-b820100f9d13"],
 " and invert at ",
 Cell[BoxData[
  FormBox[
   RowBox[{"~", 
    RowBox[{"O", "(", "\[CapitalMu]", ")"}]}], TraditionalForm]],
  ExpressionUUID->"e1c00670-04cc-4eda-87ab-028f1f89e82a"],
 ", i.e., at much greater time cost."
}], "Text",
 CellChangeTimes->{{3.727878157797224*^9, 3.72787827045693*^9}, {
  3.729023428386662*^9, 3.729023477424836*^9}, {3.729164123699872*^9, 
  3.729164253182089*^9}, {3.729181740696765*^9, 3.729181815543811*^9}, {
  3.72964339464333*^9, 3.729643452303581*^9}, {3.729797162651799*^9, 
  3.7297972726054*^9}},ExpressionUUID->"daf0d49a-a2c9-4587-a3ca-ede99b1d9b3f"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Check the A-Priori", "Subsection",
 CellChangeTimes->{{3.729181823844157*^9, 
  3.729181830180563*^9}},ExpressionUUID->"92402a7d-2756-4c5d-be35-\
ef9c170940bf"],

Cell[TextData[{
 "The final value of ",
 Cell[BoxData[
  FormBox["\[CapitalLambda]", TraditionalForm]],ExpressionUUID->
  "39d494bd-234a-46ce-b910-d7f503d343eb"],
 " (called ",
 Cell[BoxData[
  FormBox["\[CapitalPi]", TraditionalForm]],ExpressionUUID->
  "8c23b7e5-b715-408b-91a1-2fb52b1f7699"],
 " in the code, a returned value), is ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     RowBox[{
      SubscriptBox["A", "full"], "\[Transpose]"}], "\[CenterDot]", 
     SubscriptBox["A", "full"]}], "+", 
    SubscriptBox["\[CapitalLambda]", "0"]}], TraditionalForm]],
  ExpressionUUID->"1891af79-d866-486f-a629-9b2b77a22d21"],
 ". To check the code, check that the difference between \[CapitalPi] and ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     SubscriptBox["A", "full"], "\[Transpose]"}], "\[CenterDot]", 
    SubscriptBox["A", "full"]}], TraditionalForm]],ExpressionUUID->
  "d79187f3-f0a0-4931-8c09-8a661166ccf3"],
 " is ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalLambda]", "0"], TraditionalForm]],ExpressionUUID->
  "c764f547-094a-4d7e-9887-56726f224d1b"],
 ":"
}], "Text",
 CellChangeTimes->{{3.727455669635949*^9, 3.727455714844105*^9}, {
  3.727456293561727*^9, 3.727456338621636*^9}, {3.727456381984915*^9, 
  3.727456493199937*^9}, {3.7274567040936413`*^9, 3.727456704869124*^9}, {
  3.727456739701139*^9, 3.72745677855204*^9}, {3.727472821547103*^9, 
  3.727472866769026*^9}, {3.72747570063941*^9, 3.72747570624365*^9}, {
  3.727486207037271*^9, 3.727486226047611*^9}, {3.727967052949963*^9, 
  3.727967092304611*^9}, {3.72902349359485*^9, 
  3.729023506985579*^9}},ExpressionUUID->"10e22b32-ce63-43e0-bbc1-\
2dfce689e1aa"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"\[CapitalPi]", "-", 
  RowBox[{
   RowBox[{"partials", "\[Transpose]"}], ".", "partials"}]}]], "Input",
 CellChangeTimes->{{3.7274551709419003`*^9, 3.727455208922634*^9}, {
  3.727455747486219*^9, 
  3.727455758602953*^9}},ExpressionUUID->"173e6770-4fcf-4050-8c85-\
581d158fe040"],

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
   3.727485511219474*^9, 3.7274863086743803`*^9, 3.727878578292219*^9, 
   3.727880787367092*^9, 3.72788118784524*^9, 3.727881367533016*^9, 
   3.7279153851883383`*^9, 3.7279180366404953`*^9, 3.727918094433138*^9, 
   3.727924197744144*^9, {3.727927706819661*^9, 3.727927732038946*^9}, 
   3.727967810195277*^9, 3.7279687331233892`*^9, 3.7279698081358833`*^9, 
   3.727969955024419*^9, 3.728044351619812*^9, 3.7280464476574707`*^9, 
   3.728066469570793*^9, 3.7280681207187157`*^9, 3.728083783348742*^9, 
   3.728090741322768*^9, 3.728169445060842*^9, 3.728169540624917*^9, 
   3.7281698227788277`*^9, 3.728169882804495*^9, 3.728252955301944*^9, 
   3.728946255715186*^9, 3.729022899869521*^9, {3.729119978321847*^9, 
   3.7291199954270573`*^9}, 3.729121071878161*^9, 3.729121110417275*^9, 
   3.729172307287985*^9, 3.729175690293468*^9, 3.729175772153051*^9, 
   3.729183412064961*^9, {3.72918344733591*^9, 3.729183460290135*^9}, 
   3.7292559367593613`*^9, 3.729552301396994*^9, 3.729557875848024*^9, 
   3.7296298378646383`*^9, 3.7296346358091793`*^9, 3.729642872096381*^9, 
   3.7296429086974907`*^9, 3.729643938076329*^9, 3.7296471843588*^9, 
   3.7296832011663933`*^9, 3.7297781536275663`*^9, 3.7297792317673607`*^9, 
   3.729779279689464*^9, 3.729894699649646*^9, 3.729896005539929*^9, 
   3.729896152204977*^9},ExpressionUUID->"bc555716-12ca-4fb9-ac16-\
0cd7c7a5776b"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Covariance of the Estimate", "Subsection",
 CellChangeTimes->{{3.7291818416264057`*^9, 
  3.729181847224715*^9}},ExpressionUUID->"1a673c1c-26f1-4725-80e3-\
2d8a09b083a1"],

Cell[TextData[{
 "The covariance of this estimate ",
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
    RowBox[{"Variance", "\[ThinSpace]", "[", "\[ThinSpace]", 
     RowBox[{"\[CapitalZeta]", "-", 
      RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}]}], "\[ThinSpace]", "]"}], 
    "*", 
    SuperscriptBox["\[CapitalLambda]", 
     RowBox[{"-", "1"}]]}], TraditionalForm]],ExpressionUUID->
  "ed6dc5b0-2569-4482-a89f-9e45c1d9c8e7"],
 " except for a small contribution from the a-priori information ",
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
 " in the denominator of Bessel\[CloseCurlyQuote]s correction is the number \
of parameters being estimated (see ",
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
  3.727475733135212*^9}, {3.7279249725397797`*^9, 3.727924984997408*^9}, {
  3.727967100099558*^9, 3.7279671039316263`*^9}, {3.7280919485134687`*^9, 
  3.728091949527707*^9}, {3.72916432284585*^9, 3.729164348695956*^9}, {
  3.729797302412488*^9, 
  3.729797317021042*^9}},ExpressionUUID->"b538cb3d-0085-4200-af18-\
f2ded85ec33e"],

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
   3.727472952057025*^9},ExpressionUUID->"1f9a3581-c198-4dfa-9dbe-\
9a0cf6381314"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"0.002832474012328182`", 
      RowBox[{"-", "0.0028324740123281825`"}]},
     {
      RowBox[{"-", "0.002832474012328182`"}], "0.006673116740908769`"}
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
   3.727472137981408*^9, 3.727472954371911*^9, 3.727485511269794*^9, 
   3.7274863087240047`*^9, 3.727878578345954*^9, 3.7278807874127703`*^9, 
   3.7278811878958673`*^9, 3.727881367587798*^9, 3.72791538523671*^9, 
   3.727918036690276*^9, 3.7279180944824457`*^9, 3.727924197810088*^9, {
   3.727927706882574*^9, 3.727927732105157*^9}, 3.727967810245639*^9, 
   3.727968733172824*^9, 3.727969808184746*^9, 3.7279699550719757`*^9, 
   3.728044351669427*^9, 3.728046447707358*^9, 3.728066469624007*^9, 
   3.728068120768632*^9, 3.728083783416733*^9, 3.728090741371833*^9, 
   3.7281694451273947`*^9, 3.7281695406895*^9, 3.728169822844509*^9, 
   3.72816988287199*^9, 3.728252955370139*^9, 3.728946255764901*^9, 
   3.729022899921451*^9, {3.729119978388329*^9, 3.72911999549438*^9}, 
   3.729121071944837*^9, 3.729121110483716*^9, 3.7291723073551702`*^9, 
   3.7291756903603086`*^9, 3.72917577469937*^9, 3.729183412131897*^9, {
   3.729183447403452*^9, 3.729183460358261*^9}, 3.729255936823028*^9, 
   3.729552301456296*^9, 3.729557875898464*^9, 3.729629837913718*^9, 
   3.729634635859951*^9, 3.729642872142787*^9, 3.729642908767935*^9, 
   3.7296439381313267`*^9, 3.729647184407447*^9, 3.729683201217225*^9, 
   3.729778153693164*^9, 3.7297792318163977`*^9, 3.729779279861124*^9, 
   3.729894699701302*^9, 3.729896005604349*^9, 
   3.729896152277255*^9},ExpressionUUID->"33362cd6-9316-4c21-b217-\
a96ba45cfce3"]
}, Open  ]],

Cell[TextData[{
 "Except for the reversed order, this is the same covariance matrix that \
Wolfram\[CloseCurlyQuote]s ",
 Cell[BoxData[
  FormBox["LinearModel", TraditionalForm]], "Code",ExpressionUUID->
  "927b6594-6052-40b2-8ebb-205fa75a1b9c"],
 " reports:"
}], "Text",
 CellChangeTimes->{{3.727454999214408*^9, 3.7274550230616837`*^9}, {
  3.7274550552077837`*^9, 3.727455069630582*^9}, {3.727456815268976*^9, 
  3.72745682043734*^9}, {3.727462715836411*^9, 3.7274627328032312`*^9}, {
  3.7281214802053127`*^9, 
  3.72812148718871*^9}},ExpressionUUID->"c4e7898d-3f04-4052-99b7-\
cabf5e20de7a"],

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
  3.727455047125711*^9}},ExpressionUUID->"1b94fc87-4314-42b6-9ece-\
45f09bed4510"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"0.002832474012328181`", 
      RowBox[{"-", "0.002832474012328181`"}]},
     {
      RowBox[{"-", "0.002832474012328181`"}], "0.0066731167409087655`"}
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
   3.727462601420088*^9, 3.727472138034376*^9, 3.727485511317802*^9, 
   3.7274863087704897`*^9, 3.727878578395075*^9, 3.727880787467642*^9, 
   3.727881187944561*^9, 3.727881367638068*^9, 3.7279153852886133`*^9, 
   3.727918036745358*^9, 3.727918094551241*^9, 3.727924197877178*^9, {
   3.727927706952642*^9, 3.727927732168346*^9}, 3.727967810295855*^9, 
   3.7279687332273684`*^9, 3.72796980823939*^9, 3.72796995512359*^9, 
   3.728044351719689*^9, 3.728046447758238*^9, 3.728066469672233*^9, 
   3.7280681208188887`*^9, 3.728083783480638*^9, 3.7280907414232063`*^9, 
   3.728169445193625*^9, 3.728169540756772*^9, 3.728169822911014*^9, 
   3.728169882937654*^9, 3.728252955435904*^9, 3.728946255816115*^9, 
   3.729022899969944*^9, {3.729119978456131*^9, 3.729119995560389*^9}, 
   3.729121072011354*^9, 3.729121110549224*^9, 3.729172307421925*^9, 
   3.7291756904081097`*^9, 3.729175777027215*^9, 3.729183412197935*^9, {
   3.7291834474691057`*^9, 3.7291834604242697`*^9}, 3.729255936889614*^9, 
   3.729552301510076*^9, 3.729557875948141*^9, 3.729629837964074*^9, 
   3.7296346359095287`*^9, 3.729642872193766*^9, 3.729642908831292*^9, 
   3.729643938195087*^9, 3.7296471844591093`*^9, 3.729683201266974*^9, 
   3.7297781538643713`*^9, 3.729779231867325*^9, 3.729779279921195*^9, 
   3.729894699766657*^9, 3.729896005675802*^9, 
   3.729896152339327*^9},ExpressionUUID->"4e1e1118-2272-41d6-8ef0-\
b67b2bae9b92"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Don\[CloseCurlyQuote]t Invert That Matrix\.7f", "Subchapter",
 CellChangeTimes->{{3.727456856590333*^9, 3.727456866525626*^9}, {
  3.727456903416147*^9, 3.727456929038941*^9}},
 CellTags->"c:10",ExpressionUUID->"1912c569-4f5c-4ab1-a8eb-275f3be33170"],

Cell[TextData[{
 "See ",
 ButtonBox["https://www.johndcook.com/blog/2010/01/19/dont-invert-that-matrix/\
",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["https://www.johndcook.com/blog/2010/01/19/dont-invert-that-matrix/"],
     None},
  ButtonNote->
   "https://www.johndcook.com/blog/2010/01/19/dont-invert-that-matrix/"],
 " \n\nIn general, replace any occurrence of ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SuperscriptBox["A", 
     RowBox[{"-", "1"}]], "\[CenterDot]", "B"}], TraditionalForm]],
  ExpressionUUID->"32698cd4-2dcc-4b05-9117-50af35fbcccc"],
 " or ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"Inverse", "[", "A", "]"}], ".", "B"}], TraditionalForm]], "Code",
  ExpressionUUID->"0208196a-6c21-4a62-9f05-79b2f4e5fe89"],
 " with ",
 Cell[BoxData[
  FormBox[
   RowBox[{"LinearSolve", "[", 
    RowBox[{"A", ",", "B"}], "]"}], TraditionalForm]], "Code",ExpressionUUID->
  "4e7fbc22-09d2-4e39-a5b5-b93b7697af49"],
 " for arbitrary square matrix ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "776ee4c1-d1ce-42de-85cc-2ca525876f54"],
 " and arbitrary matrix ",
 Cell[BoxData[
  FormBox["B", TraditionalForm]],ExpressionUUID->
  "493b32c5-9bbd-4079-b87d-0885d8421239"],
 ". Almost all programming languages and toolkits support an efficient and \
robust analogue to Wolfram\[CloseCurlyQuote]s ",
 Cell[BoxData[
  FormBox["LinearSolve", TraditionalForm]], "Code",ExpressionUUID->
  "908053eb-6863-4781-928e-21ed138ed5fc"],
 "."
}], "Text",
 CellChangeTimes->{{3.727377065079856*^9, 3.7273770966536922`*^9}, {
  3.727456910929248*^9, 3.727456922321958*^9}, {3.727967129773798*^9, 
  3.727967138858366*^9}, {3.7279671799345827`*^9, 3.727967207643837*^9}, {
  3.7281215143410273`*^9, 3.728121560473433*^9}, {3.729023567817812*^9, 
  3.729023646362337*^9}, {3.729164385351775*^9, 3.729164386998762*^9}, {
  3.729173657472382*^9, 3.729173717927524*^9}, {3.729643492684564*^9, 
  3.729643541414435*^9}},ExpressionUUID->"ce7f532e-10a9-4ecb-81ed-\
f827034f82d4"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "update", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{
     StyleBox["update",
      Background->RGBColor[1, 1, 0]], "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"\[Xi]_", ",", "\[CapitalLambda]_"}], "}"}], ",", 
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
         StyleBox["LinearSolve",
          Background->RGBColor[0.88, 1, 0.88]], "[", 
         RowBox[{"\[CapitalPi]", ",", 
          RowBox[{"(", 
           RowBox[{
            RowBox[{
             RowBox[{"a", "\[Transpose]"}], ".", "\[Zeta]"}], "+", 
            RowBox[{"\[CapitalLambda]", ".", "\[Xi]"}]}], ")"}]}], "]"}], ",",
         "\[CapitalPi]"}], "}"}]}], "]"}]}], ";"}], 
  "\[IndentingNewLine]"}], "\[IndentingNewLine]", 
 RowBox[{"MatrixForm", "/@", 
  RowBox[{"(", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"(", GridBox[{
         {"mBar"},
         {"bBar"}
        }], ")"}], ",", "\[CapitalPi]"}], "}"}], "=", "\[IndentingNewLine]", 
    RowBox[{
     StyleBox["Fold",
      Background->RGBColor[1, 1, 0]], "[", 
     RowBox[{
      StyleBox["update",
       Background->RGBColor[1, 1, 0]], ",", 
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
   3.7274732753376427`*^9}, {3.7274734820130367`*^9, 3.727473491340034*^9}, {
   3.7289484043309593`*^9, 3.728948405468891*^9}, {3.729174099251841*^9, 
   3.7291741039734783`*^9}, 
   3.7291741376366043`*^9},ExpressionUUID->"b1e59138-e589-488f-8c5d-\
71dba55ef40c"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.6019254575589872`"},
       {
        RowBox[{"-", "0.3855034730014756`"}]}
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
   3.727473492609377*^9, 3.727485511701943*^9, 3.727486309173321*^9, 
   3.727878578445228*^9, 3.7278807875164957`*^9, 3.727881187996175*^9, 
   3.72788136768466*^9, 3.7279153853534393`*^9, 3.727918036812088*^9, 
   3.727918094615041*^9, 3.7279241979432487`*^9, {3.727927707015217*^9, 
   3.72792773222125*^9}, 3.727967810349496*^9, 3.7279687332731037`*^9, 
   3.7279698083019648`*^9, 3.7279699551693897`*^9, 3.728044351771216*^9, 
   3.7280464478070717`*^9, 3.7280664697246733`*^9, 3.728068120868615*^9, 
   3.728083783546753*^9, 3.728090741492902*^9, 3.728169445260518*^9, 
   3.728169540823485*^9, 3.728169822977787*^9, 3.7281698830032377`*^9, 
   3.728252955627798*^9, 3.728946255859652*^9, 3.72894933878874*^9, 
   3.729022900020834*^9, {3.729119978523779*^9, 3.7291199956273623`*^9}, 
   3.729121072078249*^9, 3.7291211106160603`*^9, 3.729172307489259*^9, 
   3.729174106495594*^9, 3.729174141124625*^9, 3.7291756904605827`*^9, 
   3.729175784083406*^9, 3.729183412264688*^9, {3.729183447536147*^9, 
   3.7291834604902687`*^9}, 3.729255936956237*^9, 3.7295523015566072`*^9, 
   3.729557876032403*^9, 3.72962983801383*^9, 3.729634635965757*^9, 
   3.729642872243292*^9, 3.729642908898361*^9, 3.729643938245161*^9, 
   3.7296471845136013`*^9, 3.7296832013162327`*^9, 3.729778153926168*^9, 
   3.72977923191739*^9, 3.729779279992197*^9, 3.729894699833095*^9, 
   3.7298960058062487`*^9, 
   3.729896152409284*^9},ExpressionUUID->"aa39f1a1-8476-4d14-8fbd-\
8d9906d28b15"]
}, Open  ]],

Cell[TextData[{
 "Because this example is small, ",
 Cell[BoxData[
  FormBox["Inverse", TraditionalForm]], "Code",ExpressionUUID->
  "1e8b6ec0-9f26-4e41-ac8c-020e2f7853de"],
 " has no obvious numerical issues. It is very easy to produce large, \
ill-conditioned matrices, and one will spend a lot of time and storage \
inverting them, only to get useless results."
}], "Text",
 CellChangeTimes->{{3.727473280120357*^9, 3.7274732832085*^9}, {
   3.7279911307811337`*^9, 3.727991131940103*^9}, {3.728121572695258*^9, 
   3.728121612596923*^9}, {3.729023701182482*^9, 3.729023764199581*^9}, 
   3.7291737430479116`*^9, {3.729181869246784*^9, 
   3.729181869373077*^9}},ExpressionUUID->"95bdda6c-c145-4242-952f-\
9526a2ce40d1"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Interim Conclusions", "Subchapter",
 CellChangeTimes->{{3.729164407912829*^9, 
  3.729164418350677*^9}},ExpressionUUID->"874a0d70-ffe7-4685-a3ec-\
da2ffeb72352"],

Cell[TextData[{
 "We have eliminated memory bloat by processing updates one observation at a \
time, each with its paired partial. We reduce computation time and numerical \
risk by solving a linear systems instead of inverting a matrix. We also avoid \
multiplication of ",
 Cell[BoxData[
  FormBox[
   RowBox[{"O", "(", "\[CapitalNu]", ")"}], TraditionalForm]],ExpressionUUID->
  "f1e31217-fd6e-41e1-90c4-263aba7bf238"],
 " matrices, which is of approximately ",
 Cell[BoxData[
  FormBox[
   RowBox[{"O", "(", 
    SuperscriptBox["\[CapitalNu]", "3"], ")"}], TraditionalForm]],
  ExpressionUUID->"816d662d-3cd4-47fe-8656-616095fce9ed"],
 " time."
}], "Text",
 CellChangeTimes->{{3.727475777156247*^9, 3.727475832537896*^9}, {
  3.72748624599329*^9, 3.727486246966188*^9}, {3.729023774567375*^9, 
  3.729023775311418*^9}, {3.7291818849549427`*^9, 3.729182029375617*^9}, {
  3.729644121939213*^9, 3.729644164344136*^9}, {3.729797388940627*^9, 
  3.7297974303556147`*^9}},ExpressionUUID->"b52fa788-ec4d-43d5-b1c4-\
0b86cba20048"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Sidebar: Estimating 1-Forms (Gradients)", "Chapter",
 CellChangeTimes->{{3.7273771343297157`*^9, 3.727377139800111*^9}, {
  3.7291646932512817`*^9, 3.729164695199853*^9}, {3.72917377485328*^9, 
  3.729173781833387*^9}},
 CellTags->"c:11",ExpressionUUID->"f91eb7c6-f1c4-49b5-aad9-b2ad30a42547"],

Cell[TextData[{
 "In linear algebra, vectors are conventionally columns, i.e., ",
 Cell[BoxData[
  FormBox[
   RowBox[{"n", "\[Times]", "1"}], TraditionalForm]],ExpressionUUID->
  "a6cadbf5-eaec-46e8-a3d5-eddcc2e4eb77"],
 " matrices, and covectors are rows, i.e., ",
 Cell[BoxData[
  FormBox[
   RowBox[{"1", "\[Times]", "n"}], TraditionalForm]],ExpressionUUID->
  "b7266d47-c9dc-4139-81ba-04ba699e26b9"],
 " matrices (see ",
 ButtonBox["Vector Calculus, Linear Algebra, and Differential Forms, A \
Unified Approach",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["https://www.amazon.com/Calculus-Algebra-Differential-Unified-\
Approach/dp/0971576653/"], None},
  ButtonNote->
   "https://www.amazon.com/Calculus-Algebra-Differential-Unified-Approach/dp/\
0971576653/"],
 " by John H. Hubbard and Barbara Burke Hubbard). In this language, ",
 StyleBox["dual",
  FontSlant->"Italic"],
 " means ",
 StyleBox["transpose",
  FontSlant->"Italic"],
 "."
}], "Text",
 CellChangeTimes->{{3.729171298029805*^9, 3.729171328988427*^9}, {
  3.729171450083456*^9, 
  3.729171568542794*^9}},ExpressionUUID->"8045eba4-2d5b-4de2-b703-\
f9d7b10bf773"],

Cell[TextData[{
 "When the model --- the thing we\[CloseCurlyQuote]re estimating --- is a \
covector (row-vector), e.g., a 1-form, we have the dual (transposed) problem \
to the one above. This situation arises in reinforcement learning by policy \
gradient. In that case, the observations ",
 Cell[BoxData[
  FormBox["\[CapitalOmega]", TraditionalForm]],ExpressionUUID->
  "0fcd49da-549d-4513-bc2a-55e5a3acca81"],
 " and the model ",
 Cell[BoxData[
  FormBox["\[CapitalGamma]", TraditionalForm]],ExpressionUUID->
  "c54ce737-c37c-4bf4-9780-c31893284bab"],
 " are now\.7f covectors with elements \[Omega] and \[Gamma]  instead of \
\[Zeta] and \[Xi]. The co-partials ",
 Cell[BoxData[
  FormBox["\[CapitalTheta]", TraditionalForm]],ExpressionUUID->
  "595110e6-8484-4e8f-924b-1631a75a7403"],
 " (replacing ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "a5959bab-c708-499c-8174-f99a22842500"],
 ") are now a covector of column vectors \[Theta]. The observation equation \
is ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalOmega]", "=", 
    RowBox[{"\[CapitalGamma]", "\[CenterDot]", "\[CapitalTheta]"}]}], 
   TraditionalForm]],ExpressionUUID->"1de13883-b79d-4fc7-96bd-cf06cf9564dc"],
 " and the error-so-far is ",
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
   3.7274761487187138`*^9}, {3.727485043325775*^9, 3.727485063734617*^9}, {
   3.727878432124065*^9, 3.727878474409099*^9}, 3.728948410297505*^9, {
   3.729119179477888*^9, 3.729119179623824*^9}, {3.729171586876195*^9, 
   3.729171594465631*^9}, {3.729173804727751*^9, 3.7291738082872458`*^9}, {
   3.7291820610672693`*^9, 3.7291820942076683`*^9}, 3.729644623998877*^9, {
   3.729644658106*^9, 
   3.7296446644356623`*^9}},ExpressionUUID->"d51c79dd-7095-49f4-a087-\
5de531619caf"],

Cell[BoxData[{
 FormBox[
  RowBox[{"\[Gamma]", "\[LeftArrow]", 
   RowBox[{
    RowBox[{"(", 
     RowBox[{
      RowBox[{"\[Gamma]", "\[CenterDot]", "\[CapitalLambda]"}], "+", 
      RowBox[{"\[Omega]", "\[CenterDot]", 
       RowBox[{"\[Theta]", "\[ThinSpace]", "\[Transpose]"}]}]}], 
     "\[ThinSpace]", ")"}], ".", 
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{"\[CapitalLambda]", "+", 
       RowBox[{"\[Theta]", "\[CenterDot]", 
        RowBox[{"\[Theta]", "\[ThinSpace]", "\[Transpose]"}]}]}], 
      "\[ThinSpace]", ")"}], 
     RowBox[{"-", "1"}]]}]}], TraditionalForm], "\n", 
 FormBox[
  RowBox[{"\[CapitalLambda]", "\[LeftArrow]", 
   RowBox[{"(", 
    RowBox[{"\[CapitalLambda]", "+", 
     RowBox[{"\[Theta]", "\[CenterDot]", 
      RowBox[{"\[Theta]", "\[ThinSpace]", "\[Transpose]"}]}]}], 
    "\[ThinSpace]", ")"}]}], TraditionalForm]}], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.727473769463854*^9, 3.7274737789509773`*^9}, {
  3.727473829318837*^9, 3.727473867909276*^9}, {3.727476024957868*^9, 
  3.727476030734923*^9}, {3.727476186696595*^9, 3.727476277887042*^9}, {
  3.727476413804344*^9, 3.727476415307171*^9}, {3.727519463791893*^9, 
  3.727519480366523*^9}},ExpressionUUID->"17fcc972-1a28-4152-bd4f-\
535d91af5fb4"],

Cell[TextData[{
 "straight transposes of equation 3. ",
 Cell[BoxData[
  FormBox["LinearSolve", TraditionalForm]], "Code",ExpressionUUID->
  "cb78cef6-6105-441c-b121-2693c4ccb84d"],
 " operates on the transposed right-hand side of the recurrence, and we \
transpose the solution to get the recurrence. We apply this dual model to the \
transpose of the original data:"
}], "Text",
 CellChangeTimes->{{3.727476457185042*^9, 3.727476506319212*^9}, {
  3.727476549477606*^9, 3.7274765535653963`*^9}, {3.727878507367712*^9, 
  3.727878521964983*^9}, {3.7279672954218388`*^9, 
  3.727967307737608*^9}},ExpressionUUID->"aeb51f37-12c8-4881-83e6-\
2ef32a5566f2"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Short", "[", 
  RowBox[{
   RowBox[{"Transpose", "/@", 
    RowBox[{"List", "/@", "partials"}]}], ",", "3"}], "]"}]], "Input",
 CellChangeTimes->{{3.72747707307362*^9, 3.727477115704844*^9}, {
  3.7279673222701263`*^9, 
  3.727967373721106*^9}},ExpressionUUID->"b7997bf6-125e-4ff5-af74-\
8ba42a25df9c"],

Cell[BoxData[
 TagBox[
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
      RowBox[{"{", "1.`", "}"}]}], "}"}], ",", 
    RowBox[{"\[LeftSkeleton]", "113", "\[RightSkeleton]"}], ",", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"{", "2.9322033898305087`", "}"}], ",", 
      RowBox[{"{", "1.`", "}"}]}], "}"}], ",", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"{", "2.9661016949152543`", "}"}], ",", 
      RowBox[{"{", "1.`", "}"}]}], "}"}], ",", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"{", "3.`", "}"}], ",", 
      RowBox[{"{", "1.`", "}"}]}], "}"}]}], "}"}],
  Short[#, 3]& ]], "Output",
 CellChangeTimes->{{3.727477084780794*^9, 3.727477117039559*^9}, 
   3.7274855118872547`*^9, 3.727486309346143*^9, 3.727878578500392*^9, 
   3.72788078756756*^9, 3.727881188048245*^9, 3.7278813677339783`*^9, 
   3.727915385401812*^9, 3.7279180369804287`*^9, 3.727918094667513*^9, 
   3.72792419801117*^9, {3.727927707085987*^9, 3.727927732269897*^9}, {
   3.727967328044313*^9, 3.727967374382712*^9}, 3.72796781039671*^9, 
   3.727968733327298*^9, 3.727969808356143*^9, 3.727969955220028*^9, 
   3.728044351820155*^9, 3.7280464478574*^9, 3.728066469771554*^9, 
   3.728068120919256*^9, 3.728083783615262*^9, 3.728090741576128*^9, 
   3.728169445436224*^9, 3.728169540889641*^9, 3.7281698230448112`*^9, 
   3.728169883071618*^9, 3.728252955686994*^9, 3.728946255916401*^9, 
   3.7290229000710297`*^9, {3.7291199785882177`*^9, 3.729119995691979*^9}, 
   3.7291210721447773`*^9, 3.7291211106835527`*^9, 3.729172307556221*^9, 
   3.7291756905252857`*^9, 3.729183412440611*^9, {3.729183447710875*^9, 
   3.729183460557459*^9}, 3.729255937022531*^9, 3.729552301609993*^9, 
   3.729557876084003*^9, 3.729629838065102*^9, 3.72963463602686*^9, 
   3.729642872292902*^9, 3.729642908965888*^9, 3.729643939010482*^9, 
   3.72964718527703*^9, 3.729683201999112*^9, 3.729778155298472*^9, 
   3.729779233421752*^9, 3.729779280547061*^9, 3.7298946998832893`*^9, 
   3.729896005871043*^9, 
   3.729896152537059*^9},ExpressionUUID->"595932c1-704d-4dab-9336-\
6e04eaded33d"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "coUpdate", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    StyleBox["coUpdate",
     Background->RGBColor[1, 1, 0]], "[", 
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
  RowBox[{
   StyleBox["Fold",
    Background->RGBColor[1, 1, 0]], "[", 
   RowBox[{
    StyleBox["coUpdate",
     Background->RGBColor[1, 1, 0]], ",", "\[IndentingNewLine]", 
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
   3.7274774638671503`*^9}, {3.7274774973342*^9, 3.7274775628692408`*^9}, 
   3.727967383277925*^9},ExpressionUUID->"e85911fe-41be-4e69-b677-\
7c46716d0a38"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"0.6019254575589872`", 
        RowBox[{"-", "0.3855034730014756`"}]}
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
   3.7274775639291077`*^9}, 3.727485511931388*^9, 3.7274863093907747`*^9, 
   3.727878578548321*^9, 3.727880787616843*^9, 3.727881188097982*^9, 
   3.727881367783843*^9, 3.727915385450048*^9, 3.7279180370407333`*^9, 
   3.7279180947349854`*^9, 3.727924198197872*^9, {3.727927707221209*^9, 
   3.727927732334594*^9}, 3.7279678104450483`*^9, 3.72796873339045*^9, 
   3.727969808418737*^9, 3.727969955270645*^9, 3.7280443518882*^9, 
   3.7280464479120703`*^9, 3.728066469825574*^9, 3.72806812096865*^9, 
   3.728083783681383*^9, 3.72809074183177*^9, 3.728169445494536*^9, 
   3.728169541066454*^9, 3.728169823201066*^9, 3.7281698832458076`*^9, 
   3.72825295575315*^9, 3.7289462559605093`*^9, 3.729022900119602*^9, {
   3.729119978766576*^9, 3.729119995760891*^9}, 3.729121072211591*^9, 
   3.729121110749249*^9, 3.729172307621312*^9, 3.729175690576067*^9, 
   3.729183412498708*^9, {3.729183447769383*^9, 3.7291834606631536`*^9}, 
   3.729255937096897*^9, 3.729552301655949*^9, 3.729557876131513*^9, 
   3.729629838113813*^9, 3.729634636079982*^9, 3.729642872344131*^9, 
   3.729642909034739*^9, 3.729643939060902*^9, 3.729647185325626*^9, 
   3.729683202049787*^9, 3.729778155335161*^9, 3.729779233488535*^9, 
   3.729779280608066*^9, 3.729894699935521*^9, 3.729896005941925*^9, 
   3.729896152593231*^9},ExpressionUUID->"b6ac41a7-d21f-46ec-b576-\
e61c49a57b2f"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Application of the Dual Problem", "Subchapter",
 CellChangeTimes->{{3.7274775822773733`*^9, 3.727477598570956*^9}},
 CellTags->"c:12",ExpressionUUID->"ebd311f1-47cf-4ba5-a57f-c84b66286d57"],

Cell[TextData[{
 "The finite-difference method of policy-gradient machine learning provides \
an example of this dual problem (see ",
 ButtonBox["http://www.scholarpedia.org/article/Policy_gradient_methods",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["http://www.scholarpedia.org/article/Policy_gradient_methods"], None},
  
  ButtonNote->"http://www.scholarpedia.org/article/Policy_gradient_methods"],
 "). \n\nImagine a scalar function ",
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
 ". We want to estimate its gradient covector ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[Del]", "\[Theta]"], "\[ThinSpace]", "J"}], 
   TraditionalForm]],ExpressionUUID->"1baa8577-d9b7-4297-b4ca-ceff99f13c83"],
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
     RowBox[{
      SubscriptBox["\[Del]", "\[Theta]"], "\[ThinSpace]", "J"}], 
     "\[CenterDot]", "\[CapitalDelta]\[CapitalTheta]"}], "=", 
    RowBox[{"\[CapitalDelta]", "\[ThinSpace]", "J"}]}], TraditionalForm]],
  ExpressionUUID->"7b50038e-f020-411d-a8a2-3c512776b63e"],
 ". Here, ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[Del]", "\[Theta]"], "\[ThinSpace]", "J"}], 
   TraditionalForm]],ExpressionUUID->"9f1abe83-d0e2-43da-a239-0e56844ff5d8"],
 " takes the role of the model whose state parameters ",
 Cell[BoxData[
  FormBox["\[CapitalGamma]", TraditionalForm]],ExpressionUUID->
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
     RowBox[{
      SubscriptBox["\[Del]", "\[Theta]"], "\[ThinSpace]", 
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
 ". \n\nInstead of the pseudoinverse, which is large, slow, and risky, use \
the co-update recurrence for this problem."
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
   3.727485407991457*^9}, {3.727485470328353*^9, 3.72748548941591*^9}, {
   3.727971127714642*^9, 3.727971222057963*^9}, 3.7291191797426023`*^9, {
   3.7291644828303432`*^9, 3.7291645329693336`*^9}, {3.729182106318571*^9, 
   3.7291821066066723`*^9}, {3.7296447322664423`*^9, 3.729644752148653*^9}, {
   3.729644782560891*^9, 
   3.729644805790003*^9}},ExpressionUUID->"41beab53-931e-4488-9640-\
8fde40e31d33"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Regularization By A-Priori", "Chapter",
 CellChangeTimes->{{3.7278786048568163`*^9, 3.727878609238576*^9}, {
   3.7278835476425943`*^9, 3.727883549040578*^9}, {3.727924834507627*^9, 
   3.727924836977462*^9}, {3.727925756497532*^9, 3.727925760501575*^9}, {
   3.729023822401535*^9, 3.7290238231434097`*^9}, {3.7291828363150797`*^9, 
   3.729182841338913*^9}, 3.729712704361965*^9},
 CellTags->"c:13",ExpressionUUID->"f9b31017-4c69-4804-83c7-cedc30bf1885"],

Cell[TextData[{
 "Chris Bishop\[CloseCurlyQuote]s ",
 StyleBox[ButtonBox["Pattern Recognition and Machine Learning",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["https://www.amazon.com/Pattern-Recognition-Learning-Information-\
Statistics/dp/0387310738"], None},
  ButtonNote->
   "https://www.amazon.com/Pattern-Recognition-Learning-Information-\
Statistics/dp/0387310738"],
  FontSlant->"Italic"],
 " has an extended example fitting higher-order polynomials, linear in their \
coefficients, starting in section 1.1. The higher the order of the \
polynomial, the more MLE over-fits. Bishop presents MAP regularization as a \
cure for this over-fitting. RLS and KAL already regularize, by construction. \
In this section, we relate their regularization to MAP\[CloseCurlyQuote]s.\n\n\
RLS and KAL each require an a-priori estimate of the unknown parameters and \
an a-priori uncertainty of that estimate to bootstrap recurrences. RLS takes \
the uncertainty as an ",
 StyleBox["information matrix",
  FontSlant->"Italic"],
 ". KAL takes the uncertainty as a ",
 StyleBox["covariance matrix",
  FontSlant->"Italic"],
 ". KAL additionally requires an estimate of observation noise, which arises \
in real problems and can often be estimated out-of-band. We show that RLS can \
and should be renormalized with observation noise to produce results \
equivalent to KAL and MAP."
}], "Text",
 CellChangeTimes->{{3.727878623850936*^9, 3.727878709219612*^9}, {
   3.727878861523492*^9, 3.7278788615269413`*^9}, {3.727879302741879*^9, 
   3.727879309849668*^9}, 3.727883517024404*^9, {3.727922726553706*^9, 
   3.727922764150456*^9}, 3.727922954590423*^9, {3.727924470079568*^9, 
   3.727924536073629*^9}, {3.7279245945103197`*^9, 3.727924814835289*^9}, {
   3.7279675670922203`*^9, 3.727967666149938*^9}, {3.727971057289061*^9, 
   3.727971066302681*^9}, {3.728121698098153*^9, 3.7281219113362703`*^9}, {
   3.728251250200307*^9, 3.7282512840101357`*^9}, {3.7282513246052217`*^9, 
   3.728251329374619*^9}, {3.729023929197901*^9, 3.7290239300994596`*^9}, {
   3.729164542139102*^9, 3.72916456944278*^9}, {3.729164610806293*^9, 
   3.729164677156509*^9}, {3.729164919918866*^9, 3.729165054532934*^9}, {
   3.729182136434248*^9, 3.729182214000979*^9}, {3.729191528488492*^9, 
   3.729191529399126*^9}, {3.729191562138418*^9, 3.7291916195642443`*^9}, {
   3.729644842368363*^9, 3.729644891045639*^9}, {3.72979744862106*^9, 
   3.7297974664738607`*^9}, {3.7297975040084763`*^9, 
   3.729797584823832*^9}},ExpressionUUID->"bac2eec7-91af-482b-a9c6-\
441d231b5ff2"],

Cell[CellGroupData[{

Cell["Reproducing Bishop\[CloseCurlyQuote]s Example", "Subchapter",
 CellChangeTimes->{{3.729165065884509*^9, 
  3.7291650737726173`*^9}},ExpressionUUID->"009ef6d9-eac5-46fd-8499-\
4634049578f0"],

Cell[CellGroupData[{

Cell["Bishop\[CloseCurlyQuote]s Training Set", "Subsection",
 CellChangeTimes->{{3.729182234376062*^9, 
  3.7291822398475657`*^9}},ExpressionUUID->"dcb9de58-4cb4-4b3d-9973-\
93e56920e6cf"],

Cell[TextData[{
 "First, create a sequence of ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalNu]", "=", "10"}], TraditionalForm]],ExpressionUUID->
  "6e69dab0-348e-439f-952d-c4bf86dc91a9"],
 " inputs for a ",
 StyleBox["training set",
  FontSlant->"Italic"],
 ", equally spaced in ",
 Cell[BoxData[
  FormBox[
   RowBox[{"[", 
    RowBox[{
     RowBox[{"0", ".."}], "1"}], "]"}], TraditionalForm]],ExpressionUUID->
  "29ce8c8d-9344-4003-8aa1-108c7bd407ca"],
 ". "
}], "Text",
 CellChangeTimes->{{3.727903592625655*^9, 3.727903632159232*^9}, {
   3.7279036735048943`*^9, 3.727903706547583*^9}, {3.727905942818769*^9, 
   3.727905962112603*^9}, {3.7280864904938383`*^9, 3.72808650130811*^9}, 
   3.7281253834656553`*^9, {3.7290239585551653`*^9, 3.729023962286766*^9}, {
   3.729797599233794*^9, 3.729797625818816*^9}, {3.729798320229357*^9, 
   3.729798328906424*^9}},ExpressionUUID->"8cc4ab5b-c258-42b9-830e-\
cdb7977ec279"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "bishopTrainingSetX", "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"bishopTrainingSetX", "[", "\[CapitalNu]_", "]"}], ":=", 
   RowBox[{"Array", "[", 
    RowBox[{"Identity", ",", "\[CapitalNu]", ",", 
     RowBox[{"{", 
      RowBox[{"0.", ",", "1."}], "}"}]}], "]"}]}], ";"}], "\n", 
 RowBox[{"ListPlot", "[", 
  RowBox[{"bishopTrainingSetX", "[", "10", "]"}], "]"}]}], "Input",
 CellChangeTimes->{{3.7278793831155243`*^9, 3.727879483430056*^9}, {
  3.7278795217592373`*^9, 3.7278795713344812`*^9}, {3.727879616737006*^9, 
  3.727879619545887*^9}, {3.727879705352076*^9, 3.7278797261345243`*^9}, {
  3.7278805381565742`*^9, 3.727880538743538*^9}, {3.727922980939206*^9, 
  3.7279229886203623`*^9}, {3.729797634646571*^9, 
  3.7297976426699123`*^9}},ExpressionUUID->"9ce0172d-e3e2-49fe-948d-\
a7440920e3d7"],

Cell[BoxData[
 GraphicsBox[{{}, {{}, 
    {RGBColor[0.368417, 0.506779, 0.709798], PointSize[0.012833333333333334`],
      AbsoluteThickness[1.6], 
     PointBox[{{1., 0.}, {2., 0.1111111111111111}, {3., 0.2222222222222222}, {
      4., 0.3333333333333333}, {5., 0.4444444444444444}, {6., 
      0.5555555555555556}, {7., 0.6666666666666666}, {8., 
      0.7777777777777777}, {9., 0.8888888888888888}, {10., 
      1.}}]}, {}}, {}, {}, {}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{None, None},
  AxesOrigin->{0., 0},
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
  PlotRange->{{0., 10.}, {0, 1.}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.05]}},
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{
  3.7279036576643267`*^9, 3.7279153856605663`*^9, 3.727918037116987*^9, 
   3.7279180948276176`*^9, {3.7279229839121304`*^9, 3.727922989728109*^9}, 
   3.7279241982632713`*^9, {3.727927707284925*^9, 3.727927732385895*^9}, 
   3.727967810497973*^9, 3.72796873344042*^9, 3.727969808476139*^9, 
   3.7279699553203173`*^9, 3.728044351955875*^9, 3.728046448005164*^9, 
   3.728066469870434*^9, 3.728068121014494*^9, 3.728083783783091*^9, 
   3.7280907419079514`*^9, 3.728169445558825*^9, 3.728169541122375*^9, 
   3.7281698232597103`*^9, 3.728169883302211*^9, 3.728252955818722*^9, 
   3.728946256012908*^9, 3.72902290017245*^9, {3.729119978824182*^9, 
   3.729119995825794*^9}, 3.729121072276454*^9, 3.729121110814158*^9, 
   3.729172307690002*^9, 3.729175690740155*^9, 3.7291757911047173`*^9, 
   3.729183412564513*^9, {3.729183447842392*^9, 3.729183460727846*^9}, 
   3.72925593715775*^9, 3.729552301708386*^9, 3.729557876182742*^9, 
   3.729629838166031*^9, 3.729634636127739*^9, 3.729642872393754*^9, 
   3.729642909097967*^9, 3.729643939109083*^9, 3.729647185377458*^9, 
   3.729683202099824*^9, 3.729778155387088*^9, 3.729779233549402*^9, 
   3.729779280671722*^9, 3.729797644246916*^9, 3.729894699983472*^9, 
   3.729896006002866*^9, 
   3.729896152655624*^9},ExpressionUUID->"3da08222-e167-445f-9ccd-\
c641bfe3b1f7"]
}, Open  ]],

Cell[TextData[{
 "Bishop\[CloseCurlyQuote]s ground truth is a single cycle of a sine wave. \
Add noise to a sample taken at the inputs of the training set above. Bishop \
doesn\[CloseCurlyQuote]t state his observation noise, but I guess ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[Sigma]", "z"], "=", 
    RowBox[{
     SubscriptBox["\[Sigma]", "t"], "=", "0.30"}]}], TraditionalForm]],
  ExpressionUUID->"f7563510-3ca6-49c1-a9be-eaa9281a75a2"],
 " to create a fake data set that resembles Bishop\[CloseCurlyQuote]s \
qualitatively.\n\nWolfram\[CloseCurlyQuote]s built-in ",
 Cell[BoxData[
  FormBox["NormalDistribution", TraditionalForm]], "Code",ExpressionUUID->
  "391719cb-f0ae-47d9-b6f8-cf0a16d1de30"],
 " takes the standard deviation as its second argument, not the variance. \
Mixing up standard deviation and variance is an easy mistake. Bishop\
\[CloseCurlyQuote]s notation for normal distribution takes variance as second \
argument, so beware. "
}], "Text",
 CellChangeTimes->{{3.727925037995728*^9, 3.7279251079034653`*^9}, {
  3.7281672861902847`*^9, 3.728167315662861*^9}, {3.728217520627878*^9, 
  3.7282175317062597`*^9}, {3.728217692277302*^9, 3.728217821974227*^9}, {
  3.72821832687463*^9, 3.7282183503446493`*^9}, {3.728219468837654*^9, 
  3.728219505064865*^9}, {3.728251312926087*^9, 3.728251372591283*^9}, {
  3.729024054019828*^9, 3.729024066384492*^9}, {3.7291650862455063`*^9, 
  3.7291651414164467`*^9}, {3.729165177227763*^9, 3.729165178485721*^9}, {
  3.729182224031723*^9, 3.7291822276320543`*^9}, {3.729797666011817*^9, 
  3.729797705464027*^9}},ExpressionUUID->"2f0bd73f-7302-45b7-869a-\
26b1cfd704e5"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{"bishopTrainingSetY", ",", "bishopGroundTruthY"}], "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"bishopGroundTruthY", "[", "xs_", "]"}], ":=", 
   RowBox[{
    RowBox[{
     RowBox[{"Sin", "[", 
      RowBox[{"2.", "\[Pi]", "#"}], "]"}], "&"}], "/@", "xs"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"bishopTrainingSetY", "[", 
    RowBox[{"xs_", ",", "\[Sigma]_"}], "]"}], ":=", "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"n", "=", 
       RowBox[{"Length", "@", "xs"}]}], "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{
      RowBox[{"bishopGroundTruthY", "[", "xs", "]"}], "\[IndentingNewLine]", 
      "+", 
      RowBox[{"RandomVariate", "[", 
       RowBox[{
        RowBox[{"NormalDistribution", "[", 
         RowBox[{"0.", ",", "\[Sigma]"}], "]"}], ",", "n"}], "]"}]}]}], 
    "]"}]}], ";"}]}], "Input",
 CellChangeTimes->{{3.727879752743185*^9, 3.7278799854455643`*^9}, {
  3.727880015690054*^9, 3.7278800794720173`*^9}, {3.727880507980577*^9, 
  3.7278805461972027`*^9}, {3.729175578225967*^9, 
  3.729175578232574*^9}},ExpressionUUID->"7d239325-5255-4a02-914c-\
77c2e44493a6"],

Cell[TextData[{
 "Take a sample of the outputs and assign it the names ",
 Cell[BoxData[
  FormBox["bts", TraditionalForm]], "Code",ExpressionUUID->
  "72d63cd9-b72b-47f5-b59e-8ee44c6dcc64"],
 " for ",
 Cell[BoxData[
  FormBox["bishopTrainingSet", TraditionalForm]], "Code",ExpressionUUID->
  "f9cdc4b8-56b6-4315-84c8-cce498dec61d"],
 ". It isn\[CloseCurlyQuote]t his actual training set, which I didn\
\[CloseCurlyQuote]t find in print, just my simulation."
}], "Text",
 CellChangeTimes->{{3.7278832163983307`*^9, 3.7278832375275517`*^9}, {
  3.727906008140655*^9, 3.727906061879993*^9}, {3.727967692026178*^9, 
  3.727967840843544*^9}, {3.727967872455134*^9, 3.7279678771043777`*^9}, {
  3.727969674731044*^9, 3.727969699819124*^9}, {3.727969774693037*^9, 
  3.727969782528049*^9}, {3.727969836960168*^9, 3.727969942714082*^9}, {
  3.72796998393566*^9, 3.727969992896991*^9}, {3.727970026070797*^9, 
  3.727970373300626*^9}, {3.727970485196838*^9, 3.727970512318493*^9}, {
  3.727970712603229*^9, 3.7279707772612677`*^9}, {3.727971265852014*^9, 
  3.7279713568853807`*^9}, {3.7281671900202827`*^9, 3.7281672837287903`*^9}, {
  3.728167321065092*^9, 3.728167321584338*^9}, {3.729182260744134*^9, 
  3.729182293947283*^9}, {3.7297977262479973`*^9, 
  3.729797728261697*^9}},ExpressionUUID->"1fa8518e-d009-47f2-9b22-\
0cde66c155b5"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{
   "bishopTrainingSet", ",", "bts", ",", "bishopFake", ",", 
    "bishopFakeSigma"}], "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"bishopFake", "[", 
    RowBox[{"n_", ",", "\[Sigma]_"}], "]"}], ":=", "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"xs", "=", 
       RowBox[{"bishopTrainingSetX", "[", "n", "]"}]}], "}"}], ",", 
     "\[IndentingNewLine]", 
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"ys", "=", 
         RowBox[{"bishopTrainingSetY", "[", 
          RowBox[{"xs", ",", "\[Sigma]"}], "]"}]}], "}"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"{", 
        RowBox[{"xs", ",", "ys"}], "}"}]}], "]"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"bishopFakeSigma", "=", "0.30"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"bishopTrainingSet", "=", 
   RowBox[{"bts", "=", 
    RowBox[{"bishopFake", "[", 
     RowBox[{"10", ",", "bishopFakeSigma"}], "]"}]}]}], ";"}]}], "Input",
 CellChangeTimes->{{3.72788015184029*^9, 3.727880231778208*^9}, {
   3.727880385369709*^9, 3.727880413342643*^9}, 3.727880526308257*^9, {
   3.727967805222126*^9, 3.72796780531704*^9}, {3.7279697920516977`*^9, 
   3.72796979498647*^9}, {3.727969950515656*^9, 3.727969950591378*^9}, {
   3.727994080862403*^9, 3.727994108975196*^9}, {3.729175578236166*^9, 
   3.7291756088584633`*^9}},ExpressionUUID->"f2f8376d-e871-49ff-849f-\
33fbb3198b3a"],

Cell["Make a plot like Bishop\[CloseCurlyQuote]s figure 1.7 (page 10).", \
"Text",
 CellChangeTimes->{{3.727906073807754*^9, 3.727906077471641*^9}, {
  3.727915536304657*^9, 3.7279155386681232`*^9}, {3.7279713648223457`*^9, 
  3.727971369779395*^9}},ExpressionUUID->"1a6df779-bf83-4dc6-849b-\
3173a942be9a"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"With", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"lp", "=", 
     RowBox[{"ListPlot", "[", 
      RowBox[{
       RowBox[{"bts", "\[Transpose]"}], ",", "\[IndentingNewLine]", 
       RowBox[{"PlotMarkers", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Graphics", "@", 
           RowBox[{"{", 
            RowBox[{"Blue", ",", 
             RowBox[{"Circle", "[", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"0", ",", "0"}], "}"}], ",", "1"}], "]"}]}], "}"}]}], 
          ",", ".05"}], "}"}]}]}], "]"}]}], "}"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Show", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"lp", ",", 
       RowBox[{"(*", " ", 
        RowBox[{"once", " ", "to", " ", "set", " ", "the", " ", "scale"}], 
        " ", "*)"}], "\[IndentingNewLine]", 
       RowBox[{"Plot", "[", 
        RowBox[{
         RowBox[{"Sin", "[", 
          RowBox[{"2.", "\[Pi]", " ", "x"}], "]"}], ",", 
         RowBox[{"{", 
          RowBox[{"x", ",", "0.", ",", "1."}], "}"}], ",", 
         RowBox[{"PlotStyle", "\[Rule]", 
          RowBox[{"{", 
           RowBox[{"Thick", ",", "Green"}], "}"}]}]}], "]"}], ",", 
       "\[IndentingNewLine]", "lp"}], " ", 
      RowBox[{"(*", " ", 
       RowBox[{"again", " ", "to", " ", "overdraw", " ", "the", " ", "plot"}],
        " ", "*)"}], "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{"Frame", "\[Rule]", "True"}], ",", "\[IndentingNewLine]", 
     RowBox[{"FrameLabel", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"\"\<x\>\"", ",", "\"\<t\>\""}], "}"}]}]}], "]"}]}], 
  "]"}]], "Input",
 CellChangeTimes->{{3.727880085493072*^9, 3.72788013972164*^9}, {
   3.7278802437563953`*^9, 3.7278802581076803`*^9}, {3.7278803034902487`*^9, 
   3.727880361169203*^9}, {3.7278804194474173`*^9, 3.727880429435811*^9}, 
   3.7278806446621532`*^9, {3.7278807572759333`*^9, 3.7278807745809507`*^9}, {
   3.727880893504468*^9, 3.7278809867037153`*^9}, {3.7278810338930473`*^9, 
   3.727881110077335*^9}, {3.7278811411219473`*^9, 3.7278813474824867`*^9}, {
   3.727881617681645*^9, 3.727881731860063*^9}, {3.727882548678594*^9, 
   3.72788267853528*^9}, {3.727882716394725*^9, 3.727882813824841*^9}, {
   3.727882846153562*^9, 3.727882924674261*^9}, {3.72788567102006*^9, 
   3.727885671857286*^9}, {3.727923022530311*^9, 3.727923022847533*^9}, 
   3.7291756286936607`*^9},ExpressionUUID->"c5589eba-8522-4e1e-acb7-\
54174e91a05d"],

Cell[BoxData[
 GraphicsBox[{{{}, {
     {RGBColor[0.368417, 0.506779, 0.709798], AbsolutePointSize[6], 
      AbsoluteThickness[1.6], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0., 0.1122858263996428}, Automatic, 
       Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.1111111111111111, 0.8194949350703912}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.2222222222222222, 0.5022812292450756}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.3333333333333333, 1.0720877691281738}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.4444444444444444, 0.4985961753025551}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.5555555555555556, -0.17677888580747805}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.6666666666666666, -0.8663870458898406}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.7777777777777777, -0.8982056609919014}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.8888888888888888, -0.713379308776128}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {1., 0.001682560007338969}, Automatic, 
       Scaled[{0.05, 0.05}]]}, {}}, {}, {}, {}, {}}, {{{}, {}, 
     TagBox[
      {RGBColor[0, 1, 0], Thickness[Large], Opacity[1.], 
       LineBox[CompressedData["
1:eJwVmXc81d8fxykaEhFCFEnRoCGK6i1kVxRakpBCISOaIkoisioZ0TLKykpy
7M29drLKusO995AtX/3O76/7eP5xPvdz3u/X6z3ulbVxOXl5CRcXVwY3F9f/
Pw0v05tLGOaHp4v5mgb3+R7m0ZZ07ZdQgZe5nRNSERdhb8LL2C8SOnAjKken
LdwFjBo7s+MkzOBBSuntpHAfOG038z1cwg42+L5pOBUeCr3Kj7VDJDxA7ehq
M/PnCfBG9MSjIAl/UEXz32+FZIDvii9bn0hEwn7RFB3p+wjOnE3MGBt/BwFF
34/yHaXCqn++lnobMiDfq1ylqKsT5E059PKnOaCQtoGiz+oDr6YD8HLyKwyN
dJ2tXDEI63KE+ri5EcguT+U2FBqBvAHtBsrBMvjrXr0vbZYOHfq+4yF6ZeB2
s0Bu31IGTKcXixmfLIPMB6ulC1YzQO3OgUs1V8qg1VplS8omBhSsVZ4uCS8D
HYbYETVjBnzVkZTJppeB7ZUkEe54BhR9GHOPjCyHE12dnmoHmVDmGLf+LKsC
PonRm17YjMIXhpOT1XQFfPt3fuNXx1F4d1X9my1XJUTaRTS2uo1CgH3nOWeR
Sig0uqkx5TcK+jZCMQ8PVoLq8aAt9KRRoJwNEE8ProRsW/mnwb9HoUf/uujS
nVUgGW12vewsCxqrNS6vUKuCD6VLalddYkGxLl/u6iNVcKznp+7xqyxI0Plo
Jm5eBR6tS5OKb7LARvN3xM57VRCW7fbeOIIFdDVz4TONVVCvI2AtVc+CqS2H
BD9fr4bH5mj6/j42HB7Qqg7yrgb3abkg94NseBSn73P1YTXc3rSr4aI2G8RE
zLDcq2pQSrQ222jKBlVuJ0pMRTWoJT0/rH6NDd7dL0MD19dAyf67jb1v2LAQ
OiloV1sDwk7q7KalHNAxmq8+0lYDF4c6s3NXciB4GdeDjf01EGSXz4oQ5ID0
vVVjPydrgHn+eZ7qeg4cdtxENZWphbM5Tz1E93DAR8ckDLxqYaDcdZeqFQeW
zKWtWS9fBw5+Dv1zGRxY36g1Acp10J8tZXs7hwMqiV3tdgfqwEut0WCigAOX
DZa/Tj9WB89iCzSaSjlQ88pGXutmHfzSk4tQaOVAqLqEukN1Haz8r1nWeZID
yQKZUs+a60A65pqZxywHSgZ0/2V310FFgWKX2wIH/gR5VCzgOgiBde1neDBY
dFOOh4nXA4TdvVOzFoPU3Ue2+Q71oJYWm75vN4Z9JtK6Pe718Kv+S1iJCobj
m3MUuO/Xw0Pu+Vzt/Rh8Gn6zDcPr4Sv1VdUewDAgdci7r7AeuIMO0b8YY0j5
PhHMy98AmCXuccQeQ9nzIJdtYg1Q69m22cQBw8/LsidPyDQAuzRv1elrGPgF
Tqx7pdIAY7zj3sfcMLhapSbuuNAAr+Syi3ruYVD9Z513Kr0Bziu7GPlHYDA+
VuJ3tKAB/hgkbV8ZjcH29cYTamUNYMDiCnj0EkOYWh9NsqMBOGsH3zjGYWC4
nJcY+K8Bph4IXv/xAQNXceFw6/JGONVnv0w2BYMYv2R2pVAjrF5xQcQmDYNW
8g/DFPlG6A7gDm7MwBD7y/yu67FGqDYM7zYowJCtlKtvc7oRlKLVV1kUYqi5
KyJqdqkRirmupp0rwjAl3vpZzbMRWsKvaBwrIfEzNelfjG0EO7XJ4M5qDNxl
hlohrEbYt3Fp5IN2DOJrUgV8phth+1X16LWdGJSsVna7cjVBfoT0koQfGM7N
V7ubiTRB5m1X0YRuDDl7jr5ff7AJShSvyej8xlD34N2N1bpN8N5Xwj5mAMOv
pqWH/51ogl1RX4QZgxhWO5V1DNg2AavYNcFlBIP9W1iR+rQJclRr7suOYrg7
Ht/2OqoJHnY9nlBnYYiAxTchCU0gNkZvMGZjKOkuOnDjSxNkawV/OosxdChK
LbP93gQy10yzzcYwsLzutJhVN4H60Pf1+uMYJETUnfZ3N0FXyAdx8QkMu2xe
qW0bboIxpZy0ScK6mbNLpXATTP73NLF2EoObcX7svyUUaJqj5lhOYwiMEXMY
56fAKsm+ZskZDAl0z32DYhQQOzFl0ky4wV+lqWobBUzbozy2zmFQF6xf8nwf
BYJ5fpu0EU5+dUntvCYFepM7VbznSX43zzrJG1HgeY2RzNq/GB6mP3uDzSmg
zBFa+57w2H759q/WFHikwL1aaQGDVfm3lf5OFMjlm1idTlj9B91N3JcC/yWb
bo74jzzfxufjwFMKHJe9f2CWsBhbtOdTNAUWvu4wN1vE4O/1aY1XIgVOx2p7
fSQ8zq199MgnCqjeTEsYJ2wV3HVrVT4F/t060bTnH7mPmGt6eykFPltJL3Ui
rJ64bDChgQKtF3kPxxBO3h63zrGTAu8Pzd8vISyWt9dYZYACMwfHK3sJ+2vW
PVhkUUB764DwH8J/6qxza2YokGpYffk/wpmpfz0MuKkweSuu+B9hGtYNTV9G
hSh+O+k5whv2haes5adCWp+UH4Ow2e3ecm8hKiyYNLCohJ8ihb5eMSpM69+6
kEG4jMdjVkuKChm7drb5E541QMLJslTon54wMSWsHMq3c/VWwgI9rSKE7dvM
9dx2UOGt67Qlhdw/TiLxUuduKnx9acF6QLjNinXnoBoVDgcK+ykSXvVOLTrx
IBV6KrQ21JL4ajH8MpdpUaHszJLSi4RvKTXVOelRIb7F2ZFN8pPpLjFMNaZC
6NFkSTfCtAK7f/tOUkHOoLmZTfK7YTFD4vVpKhjNCYRZEzbX/ruX6wIVjKcD
zeuIPoIDdY9ftqHCdzuHTdsJzwn3+ilfp4LHd+HW5lmi3zMKcZFu5P4BB/PX
EbaPc8+f86KC5t1nb82IHtu28rHK/ajgcz4w6ssUeZ+DauZnXlJhZ6LzMO8f
8j6+fi7f40h8Z2yEeIg/NlQ3Ptn0lgrW2Xf05oifgk3tilmfqYBV9FtriN+u
2j/f6ltOhSaj9W4LdKL/tJ4jIzVUkFmBZ7JpxH9jWy2NmqigdMg/yJr4WedO
cZhoFxWWmN3ofEP8vjFsdC6FQ4UTkRbr83oxFF/yScmeoALzupuyZg/R3961
Z7/NUiEu4u6dsp+kvnWoFzQsaYas5y1FGaT+iEsH3cRizXDukjLe0YwhnyO9
ZXZ9M6yxONfoTSH9oySrnUu2GbZGh48UNWKIsu1SEd7eDOwnffU76zAIpypM
qEAzjN5Qc84uw5B1pyjpkE4zeKYK7y4h9dDkmMlJXYNmaIyP2FNVjCF0zCvr
9Klm+Dl5c6KQ1FN+tWqX21eagXe8+LZeNgbeisssFNoM+fOXRdkJGN5Fzb2u
iWwG6v10Lh9S33WuhBg1v2qGBr4De1e+xuDHl5s68LYZSu3vuS4j/WHRhMeB
t6AZ6sb4L7x7SvTamzRs+KsZ4qfLnjl7Yhid6e9r39UClYH8Gke0MeRdCS0z
VG2BvPWe8pGkvz3oPPwBabRA/NFd4n0axH/5cddTdFvIPDkoeZr0R62b5xfu
WrZAj3/Wl97NGGImOyQ2B7ZAypMZpcOk3+qPN5q59bfA/ejBbLMiDqy9dG8/
bagFDmUGMILyOdBH3SFlyWyB0tP+JwqyOeCR+XTw6FQLLOOTy5hN5kCCi4Gb
xKpW+BJydEgwigPT7IrQEtVWcEi75PDKiQPvmN/qBJ61AuIduCsnzAHnFyfk
HCNaIchXf50VPwfUdAbvVL5shfyPijZhyzhQF8e38+7bVrgyWCvYM8+GcZOz
oYyCVlBU5pkVHCTzVf70qYrBVhgfmHAZzWJD18PdvbcOtEGS94zQPQM2CEh/
xENDbWAu8kve3ZoFmhYPewcZbWCZGZusROY/t9CL9QOcNrBOjTk7aMqCDm7x
j79m22Cj9KVj+7VZED8SaNXD3w5rrr35HCbPAqVMx8ZWlXbIbnk0sEAfhWPa
Smll/u3g2cnFRSXzabBDrv2bzR1Q/TjwbOM5JjA1Pweu2tYBlP7yEVlTJuiJ
v0+9qdwBp+YCuF30mLCkOpJjrN4BnX9jmH/2MuHWZo+bcyc6oKbg8o9EfibY
9+95dPJOB3gU60bGFzHgiHnme56WDvAJ1w3cuo7M35ppQ1d9OsFUbWJIOp8G
HnsqcsTKfwDX9HKKa/8Q9KdXPG2W/QkNJy8rPnT+DX8d214r3u6GM1S9yL33
u2H7keWL9t964NOIcWKNUhvoJcleyVrXByWrbim4tVWDl/TFTb8t++FPO7/9
Ilcm7GCZr+o89gv2t1htyAhOR2sFx1ZUzP8CKxGZg++9ahAPep0hF/sb3mzN
3qw73IqcVL51rTQaAOO6hBSVn90ozcDmTfH0AHy9tSu3PPo3mhqVXDMSPQgm
YW/PWH4bQrmn9JZG6gzByRChwS21NBRoVBAgpTcEDgnlhbWtNGSprbjivcEQ
MPGpz/Z9NLRk76rVeccJL4T+eDZBQ8eFKWI/zgyBZbjx4gtpOqJTLbZJXR8C
nW02Wk9d6UjyuL3pu6ghUhftOgeFGMhHPyAhZ2QIFGst/FqPMFGL1VXLXYwh
sMhbGvPNkIk2expJfBodgmN99jfiTjFRXaJQxNuxISjs7rM4fpmJRP7GPQqf
H4LI0eZSu0AmSv6cd91VYBheHw/TtWlkIqowXWOH6jAEXVqgPj85ijYp1s9+
3D8Mhk9Ehz+fG0WekJ4rpzEMr6IPepfbjCLJax7K6zWHYS6LV6TbbRTZVXLJ
8RkOwwfaWta38FE06yXBR78wDCxKoZdW8yiS7TX88TZgGIyOHpGyMGChoDKN
DPPAYSj43k05aMpCfz7ueLT86TAsFxSMJosVKnMTUHEKGwYVCzfT0qssZLei
JXTP62F4mL9M7/NjFkree1avNHMYyq0jjHgrWEgp6EpeX/cwOKwIlv2oykbR
LmdCwvqGofNKi0DwITb6Z2Zgp/V7GKwVghqu6rARdeN24Q8jw3CS+SZr5Uk2
upHLuX59fBi6qLvZ9GtslPPLU35h2QioyiQ9Xp/IRupq/pESe0ZgRs44S2cp
B3XYSKjGqYzA6aLIiW8rOMj9WXqnjNoIhDyXGdouwEGfhn9IKhwcgc7+vLop
cQ7aELkzUVV3BASeqzzZrcRBS8Y7Pp86NwK/d674pHeag+pTFatD/EagO0GQ
NfyWg652FF8VChgBzUzdQNdkDuJZYsYX9XgEcjza0yY+cdDhs/ePxQaPQPFw
lP9gLgdlLm9tTY0eAY01RlYO1RwUaXf3V3XqCPDm1FbyMzjIcgNljrt1BKyS
bC6mbcFIQMIt91v7CBjV7loWvg2j0rWiNzx/jIAra0mJixJGW1aep9N7RyBi
VO/qGlWM8MRIB4U+Aiz3qWsjOhj51S5+iVscgUgHY8sha4xUKhJdTnPTQGlG
LEfDDiNasc52IR4anKBdEgi6gpFxTlCS/0oaSE5nVa1yxkg0Qey5kwgNJo3O
7Xh7G6NkDyXnA9toZG8AXtlwjM65NCtO7KABfiEqQY/EaLWjx/AnZRqc/++O
7IcXGLldLLSU2UeDmC8d/MvjMNIw1DVarkkDxWCH/ZYfMeLoMJaVatHgvd/J
7p8pGL2B4LLbR2lw5E79NZNPGPHsaznAMaSBe0f8GZksjJo2Wim0m9Ngr3ue
5qlCjB5Icg89O0ODZ8GzOk+KMNor+i5B/zy5H++NPXnFGL3kY4oVWdNgV+aT
qskyjGymPHnfOtHAeWVwGU89RlN1IQOuvjQ4vH7iqUsXRj2r2q8uPKSBLv9r
k9mfGJUZS+HHj2igOdUtc6sHo7Cm1L/xT2ngZZw6YNOP0baWapHGKHKf9+6/
O4YwWrNW8PWZlzQYX0qd3TiC0cwpC9mhGBrYai2IX6JhVNE+tPNvAg2+vwpw
q2dgZNXFraeYSuKJ1vppcjDSkTRozPlEgzGNV50GGKPt58NOaWbQQKTx3V6j
MYxmezZYn86hwUeJE4v7/mDUJ20/MpBHA29d92sbJzCqtPp8zfkrYUeFX1yT
GIX/0rgVUEyDN3b2nWlTGHnLPvy3ppQGFrH+5zynMbpoUxcQW06DG8+sBlRn
MNoxdCb8Sw0NNpg++pc4i5Gw/BtxqKfBWs9bkUZzGM1dpsXXNdLAYN5tJ5tw
Fc0z7XcLDa5+73IU/4vRJ4Xvu6+3E70cWRBIIhzhwFMw20kD0dzQPLkFjG6n
Gh32/0kDlzz3S3GErUfDKwR7aaA69ERQ8D+MdHf8NHzdTwPozi3xJrzzumzz
lgEa8Kj1evwkLJJ+9XT2EA2Sn9O2qyxiNM/J6D1Eo8Hiw+LhAMK/lGdsaxk0
iHh/LInM26ja9TDTjEWDT8F+l4T+YZSeFeD6i0ODU03GckaEI/80TDuN08Bk
MY52l/CdvSL3ZiZooJ7hkP6BsI3H+aUPp2lw3Y10I8L6uUlPBOZosO6HvvYA
YeVphmDMX6JHl2NCk4TF1HZHyy/SIKwy/TfZP9CCl7dUFhcdmq445pD9Aw0W
oKSDS+lg/dvnCdk/UN3cMsUaXjoEF41ZjxLOVD+ecWoFHa75lai3E35xJ2pf
Px8d2IWTYvmE7xf1fHNcTYdaVuRUGGG7/+S0pgXJ+bjUDhvChoedanyF6RBi
eqRwB+HdPtnHV4vSgfXU/g2HxEO8ZK7t5To6hDcpPkkmvMh15PxmSTpsiYn1
OEd46Ejg7wwpOqxxbrHhIVzvR7misZEOrjW/Tn0g8X/JY+VxcjN5/hLa4RaS
v0Xbdfuat9DB0YYrzoqwXTl16oQiHToqi44Nkvzv8tP2OqZEh3/N0R/b5zGK
/r2g1rCLDrp7p0y0CS9o5s0a7qXDxpXex1KInmr+KdzW308H7+oHmlZEf0oX
B9Sr1elwUt5C7TPRZ2Tx679HD9Hh4gDHd5Lo1/qewD1tLTqs/Ci99hrR98z8
hM9hYzqsyP6+7d84RpbnPmt+P06H03c5FWsIl3215z5oSoepXu8cSeKnZ95d
fgcs6JB2JzByHfHfluniABVrOnjk3b2YS/wZbO6t+8WGDlUci7QndIz+5Oxe
vucyHWILo49bED8Xu78LVHYk5+ddYn8Q/1uMP3m6zYMOnwMErHxJfSgy0TZO
uUkH5lDIdfE+jDZlLvAr3KLDU+/Jjo+knnCcXZ7J36eD+p+fBRmk/gSwzJ7L
BNIhh7Gz3LYVI6aRwMmEIDoM18+nfW/GyCStWnhDCB3uc38YF6RiJOWoHrk+
nA76Tfui4howyqFtfCEWSwcxq2n9C5UYSep1nY6Kp0Omp93m2+WkXn4IFxdJ
pIOJibR1aCmp95d5Y4Q+kPMn9OeTvpP8DzBj+TPpIDf8o8o5F6O1fblJSyro
8FwydPertyRe/Pfu5VfRyZyYl78iESM+DZ0z12pJvEHnhEs8RktetqzuaKKD
D+tRruwrEi9T7J3SRYe9Vq3u659hRK1UOGGC6bDJVMnB9ib5/kmsyPuHDoqN
52x13En+N+XzFE7S4Rz15x0pV4yQz9FCuXmSjydXV2U7EP8esJGf4WHAzVHj
YjdLkp/Pr//GSTJg9VJufSNNjFb02HSclGZA+/GWF/EHMfLn25a1XIYBVZ2X
RRn7ib+vFNjfkGfAfPqyeNvdGDnKtjfr7GKAzx6ZpViW+DtKIHn0KAP6WBdF
rLkx4r3na3bgBgNqG4PCv3zloJxx1hxyZ0BhVqqvJunndvZnEnRvMsD2Ou9g
ZSYHVZxQZp66w4C6++1chR85yH9Tr49zAAMG7ynV6EWR+aBmf9rbVwx4m2H0
aN6ZzBdrx7gFyhjw9ZO5fKUUB2U/Pv8xsoIB+xs2JNms4yCbhSrj9dUMKBOe
zZ8V4qCy4bgXCg0MCA3flSOwnIP8Cox2ancwIDbeU2RgjI24rT6e8WYyoLdG
PnlrORtxpVhlDAgzoYcWI7Hfho2qWJ3OCaJM6Gj6omx3no2Cd5kqWYozIXWs
pe6xGRutK9D+3C7NBJ7WtS9zddlIqVohrUaBCdSHBVVp29jIcvjPh/TDTPDi
MT3EM85CX2Ufx992ZAKlQNTcw4uF3GIyQoTLmGB8kb2X4jSK8hdiHpdVMMHd
4PbudbajaMHqka9bNRNG534/O03m1cdyFzxbGpjQrrzEvVR/FMV+4rsQ3smE
tnWa8uryo6iy+PIOYTYTYNLZqrSHicQH19cLiY9CEPX8zH5dJvq+PXCFkPMo
lNtWyNosZSAhQ7cdfgIsuHyUz7Dx4gjq2UltvVXEgsminY5FsoMoMx42D1mx
wdGtsLL8RT+6kKEqJL3IBtl8s8LqiB/oQUCib08qBzh9P6plnlHRZ7r0awFj
DK9vWiZLx5aiwLgA677jGIp4rZWkLUqR3Um2fLophk+Meqd1a0qRVFFR5rHT
GCZ4NWwWHpagoNDzVcE2GJ54VGwR7SxGV1VfjfPdwtBKF7sZ5V6INvmL6C//
gKHlWvzqXx+y0OL+u6s7kzEc+NHZ3S+RhbrYgy0f0jDIPWx3/xmcicJOf7mg
m4Vh0E/4nO9wOvq37aR7QBHZs+8ojaXdTUU9zaHxS1sxTKdEbYlISUQFj2Zs
W9sx3HRyMRYJfYMiNS4qvv2BoTssp0GGEY+M3ivlaPVhoOq/ipu6H4MKvRtr
fRkYfukkFGqnPkfRO/eFmrIw2G0x1FjDfIZuDMSayWIMeyZsokJ9gpCC8bX+
kkkMze20K16pvoiHu+1d2AyGzcL9myp9bqNfuRqO1vMYviZ52kSk3kBFjm+V
d/2HQS32uk9B6iX0YuOqqf//Lrd5d8j//98q/h8q4Y1y
        "]]},
      Annotation[#, "Charting`Private`Tag$2692#1"]& ]}, {}, {}}, {{}, {
     {RGBColor[0.368417, 0.506779, 0.709798], AbsolutePointSize[6], 
      AbsoluteThickness[1.6], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0., 0.1122858263996428}, Automatic, 
       Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.1111111111111111, 0.8194949350703912}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.2222222222222222, 0.5022812292450756}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.3333333333333333, 1.0720877691281738}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.4444444444444444, 0.4985961753025551}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.5555555555555556, -0.17677888580747805}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.6666666666666666, -0.8663870458898406}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.7777777777777777, -0.8982056609919014}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {0.8888888888888888, -0.713379308776128}, 
       Automatic, Scaled[{0.05, 0.05}]], InsetBox[
       GraphicsBox[
        {RGBColor[0, 0, 1], AbsolutePointSize[6], AbsoluteThickness[1.6], 
         CircleBox[{0, 0}]}], {1., 0.001682560007338969}, Automatic, 
       Scaled[{0.05, 0.05}]]}, {}}, {}, {}, {}, {}}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{None, None},
  AxesOrigin->{0, 0},
  DisplayFunction->Identity,
  Frame->True,
  FrameLabel->{
    FormBox["\"x\"", TraditionalForm], 
    FormBox["\"t\"", TraditionalForm]},
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
  PlotRange->{{0, 1.}, {-0.8982056609919014, 1.0720877691281738`}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.05], 
     Scaled[0.05]}},
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{{3.727880775294775*^9, 3.727880787730764*^9}, {
   3.727880934685656*^9, 3.7278809872854*^9}, {3.727881034647586*^9, 
   3.72788111070538*^9}, {3.727881149340519*^9, 3.727881273359902*^9}, {
   3.727881331668276*^9, 3.727881367908173*^9}, {3.727881679253851*^9, 
   3.727881732639435*^9}, {3.727882562737458*^9, 3.727882578070189*^9}, {
   3.727882623588429*^9, 3.727882694410623*^9}, {3.727882734556818*^9, 
   3.727882799272423*^9}, {3.727882852380828*^9, 3.727882925334324*^9}, 
   3.7278856759136066`*^9, 3.7278870450627317`*^9, 3.7279153858103523`*^9, 
   3.72791803725655*^9, 3.72791809498518*^9, 3.727923023895686*^9, 
   3.7279241984537888`*^9, 3.727925186689782*^9, {3.7279277074383373`*^9, 
   3.727927732567607*^9}, 3.727967810615572*^9, 3.7279687335582027`*^9, 
   3.727969808589816*^9, 3.7279699554358187`*^9, 3.7280443521874313`*^9, 
   3.728046448171671*^9, 3.7280664700061007`*^9, 3.728068121166772*^9, 
   3.7280837839406548`*^9, 3.728090742104409*^9, 3.728169445708262*^9, 
   3.728169541253911*^9, 3.728169823409259*^9, 3.728169883432933*^9, 
   3.728252955971521*^9, 3.728946256243698*^9, 3.729022900259424*^9, {
   3.729119978973509*^9, 3.729119995969993*^9}, 3.7291210724993067`*^9, 
   3.7291211109977207`*^9, 3.7291723078683023`*^9, 3.7291756908751507`*^9, 
   3.7291757981263313`*^9, 3.729183412685206*^9, {3.72918344796786*^9, 
   3.7291834608971157`*^9}, 3.729255937258317*^9, 3.729552301814382*^9, 
   3.72955787630888*^9, 3.7296298382718487`*^9, 3.729634636236637*^9, 
   3.7296428725154552`*^9, 3.7296429092535467`*^9, 3.7296439391961117`*^9, 
   3.729647185507022*^9, 3.7296832022027597`*^9, 3.729778155560172*^9, 
   3.729779233716967*^9, 3.729779280842063*^9, 3.729894700122344*^9, 
   3.72989600617513*^9, 
   3.729896152791457*^9},ExpressionUUID->"95dc61d2-8828-4d02-9689-\
48a500d62af5"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Partials: Gradients of the Unknown Parameters", "Subsection",
 CellChangeTimes->{{3.729182306493725*^9, 
  3.7291823233798018`*^9}},ExpressionUUID->"23dbd351-27ff-4dfe-b5df-\
4bf18e84e52d"],

Cell[TextData[{
 "Write a function for partials. Quietly map the indeterminate ",
 Cell[BoxData[
  FormBox[
   SuperscriptBox["0", "0"], TraditionalForm]],ExpressionUUID->
  "b579cedc-762e-4d8b-9c45-f853e45c0428"],
 " to 1. Test it symbolically."
}], "Text",
 CellChangeTimes->{{3.727925195515706*^9, 3.727925232785982*^9}, {
   3.7279678941263742`*^9, 3.727967900133898*^9}, {3.72797367998691*^9, 
   3.727973685039398*^9}, 3.728086523246662*^9, {3.72816734159263*^9, 
   3.7281673598690157`*^9}},ExpressionUUID->"fc8d2ebf-e5bd-4f37-84a7-\
0a0d1a14e585"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "partialsFn", "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"partialsFn", "[", 
    RowBox[{"order_", ",", "xs_"}], "]"}], ":=", "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{
     RowBox[{"Transpose", "@", 
      RowBox[{"Quiet", "@", 
       RowBox[{"Table", "[", 
        RowBox[{
         RowBox[{
          SuperscriptBox["#", 
           RowBox[{"i", "-", "1"}]], "/.", 
          RowBox[{"{", 
           RowBox[{"Indeterminate", "\[Rule]", "1"}], "}"}]}], ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", 
           RowBox[{"order", "+", "1"}]}], "}"}]}], "]"}]}]}], "&"}], "@", 
    "xs"}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"MatrixForm", "@", 
  RowBox[{"partialsFn", "[", 
   RowBox[{"6", ",", 
    RowBox[{"{", 
     RowBox[{
      SubscriptBox["x", "1"], ",", 
      SubscriptBox["x", "2"], ",", 
      SubscriptBox["x", "\[CapitalMu]"]}], "}"}]}], "]"}]}]}], "Input",
 CellChangeTimes->{{3.727887092392867*^9, 3.7278870953121367`*^9}, {
  3.7278927196950607`*^9, 3.727893003172378*^9}, {3.727903114052039*^9, 
  3.7279031476650763`*^9}, {3.7279033176045437`*^9, 3.727903339378933*^9}, {
  3.727915570017507*^9, 3.727915600803166*^9}, {3.7279156539215097`*^9, 
  3.727915686797736*^9}, {3.727923101166524*^9, 
  3.727923181040741*^9}},ExpressionUUID->"5d13c4a6-9ba4-485a-8b9a-\
60596bd63d30"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"1", 
      SubscriptBox["x", "1"], 
      SubsuperscriptBox["x", "1", "2"], 
      SubsuperscriptBox["x", "1", "3"], 
      SubsuperscriptBox["x", "1", "4"], 
      SubsuperscriptBox["x", "1", "5"], 
      SubsuperscriptBox["x", "1", "6"]},
     {"1", 
      SubscriptBox["x", "2"], 
      SubsuperscriptBox["x", "2", "2"], 
      SubsuperscriptBox["x", "2", "3"], 
      SubsuperscriptBox["x", "2", "4"], 
      SubsuperscriptBox["x", "2", "5"], 
      SubsuperscriptBox["x", "2", "6"]},
     {"1", 
      SubscriptBox["x", "\[CapitalMu]"], 
      SubsuperscriptBox["x", "\[CapitalMu]", "2"], 
      SubsuperscriptBox["x", "\[CapitalMu]", "3"], 
      SubsuperscriptBox["x", "\[CapitalMu]", "4"], 
      SubsuperscriptBox["x", "\[CapitalMu]", "5"], 
      SubsuperscriptBox["x", "\[CapitalMu]", "6"]}
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
 CellChangeTimes->{{3.7279231186573143`*^9, 3.7279231819525948`*^9}, 
   3.7279241985452023`*^9, {3.727927707499826*^9, 3.727927732638883*^9}, 
   3.7279678106408577`*^9, 3.727968733627557*^9, 3.727969808625535*^9, 
   3.727969955460413*^9, 3.728044352257525*^9, 3.728046448251258*^9, 
   3.728066470133565*^9, 3.728068121219434*^9, 3.728083784014492*^9, 
   3.728090742211894*^9, 3.728169445777561*^9, 3.728169541293954*^9, 
   3.7281698234776993`*^9, 3.728169883478408*^9, 3.728252956051774*^9, 
   3.728946256298505*^9, 3.729022900282452*^9, {3.729119979041417*^9, 
   3.7291199960654287`*^9}, 3.729121072577467*^9, 3.729121111088888*^9, 
   3.729172307938603*^9, 3.729175690912595*^9, 3.729175799963489*^9, 
   3.729183412718895*^9, {3.729183448005946*^9, 3.729183460929661*^9}, 
   3.7292559373083487`*^9, 3.7295523018487167`*^9, 3.729557876329398*^9, 
   3.729629838290058*^9, 3.729634636267157*^9, 3.729642872549694*^9, 
   3.729642909372253*^9, 3.729643939223579*^9, 3.7296471855760403`*^9, 
   3.729683202239718*^9, 3.729778155623721*^9, 3.7297792337834044`*^9, 
   3.729779280904265*^9, 3.729894700189678*^9, 3.729896006236771*^9, 
   3.729896152859838*^9},ExpressionUUID->"0a6690b2-cf47-421a-b393-\
debee3f8c1c4"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["The MAP Equations", "Subsection",
 CellChangeTimes->{{3.7291823695201817`*^9, 
  3.7291823731744957`*^9}},ExpressionUUID->"a57e1e06-d89f-4a6b-90ba-\
b18e5094f5ad"],

Cell[TextData[{
 "Confer Bishop\[CloseCurlyQuote]s equation 3.3, page 138, where he writes \
the parameters to estimate as ",
 Cell[BoxData[
  FormBox[
   StyleBox["w",
    FontWeight->"Bold"], TraditionalForm]],ExpressionUUID->
  "f93adc3c-853e-4c72-9d86-2aa88377c8d3"],
 " and the observation equation as"
}], "Text",
 CellChangeTimes->{{3.727967934130774*^9, 3.727967994255875*^9}, {
  3.728167384043807*^9, 3.7281673844840384`*^9}, {3.7282203912603188`*^9, 
  3.728220431494154*^9}, {3.7282205477554483`*^9, 3.728220580377705*^9}, {
  3.728220691138853*^9, 3.72822075490273*^9}, {3.728222921609508*^9, 
  3.728222923769473*^9}, {3.72822433008339*^9, 
  3.728224339280476*^9}},ExpressionUUID->"83a04645-300b-4fe9-9950-\
859db8a309da"],

Cell[BoxData[
 FormBox[
  RowBox[{
   RowBox[{"y", "(", 
    RowBox[{
     StyleBox["x",
      FontWeight->"Bold"], 
     StyleBox[",",
      FontWeight->"Plain"], 
     StyleBox[" ",
      FontWeight->"Plain"], 
     StyleBox["w",
      FontWeight->"Bold"]}], 
    StyleBox[")",
     FontWeight->"Plain"]}], 
   StyleBox["=",
    FontWeight->"Plain"], 
   RowBox[{
    UnderoverscriptBox["\[Sum]", 
     RowBox[{"j", "=", "0"}], "\[CapitalMu]"], 
    RowBox[{
     SubscriptBox[
      StyleBox["w",
       FontWeight->"Plain"], "j"], 
     RowBox[{
      SubscriptBox["\[Phi]", 
       RowBox[{"\[ThinSpace]", "j"}]], "\[ThinSpace]", "(", 
      StyleBox["x",
       FontWeight->"Bold"], ")"}]}]}]}], TraditionalForm]], "DisplayFormula",
 CellChangeTimes->{{3.7282207613079443`*^9, 3.728220889669578*^9}, {
  3.728221929311122*^9, 3.728221929312549*^9}, {3.7282229942899933`*^9, 
  3.728223000986117*^9}, {3.728251451814763*^9, 
  3.728251478938428*^9}},ExpressionUUID->"fad6048c-0c22-4427-bb8f-\
a76fd37cf669"],

Cell[TextData[{
 "(",
 StyleBox["bias",
  FontSlant->"Italic"],
 " incorporated as coefficient ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["w", "0"], TraditionalForm]],ExpressionUUID->
  "47a29354-35e1-4999-8a23-378844599a74"],
 " of ",
 Cell[BoxData[
  FormBox[
   SuperscriptBox["0", "th"], TraditionalForm]],ExpressionUUID->
  "856ceccb-b337-46f7-acfb-9cde919fa114"],
 " basis function). This is predictive: you give me concrete inputs ",
 Cell[BoxData[
  FormBox[
   StyleBox["x",
    FontWeight->"Bold"], TraditionalForm]],ExpressionUUID->
  "15dedbdc-ea13-4583-be2d-b0f2fd3052c4"],
 ", parameters ",
 Cell[BoxData[
  FormBox[
   StyleBox["w",
    FontWeight->"Bold"], TraditionalForm]],ExpressionUUID->
  "5c7a5a42-af1e-409a-a658-bfca1a86f03c"],
 ", and I\[CloseCurlyQuote]ll give you a predicted observation ",
 Cell[BoxData[
  FormBox["y", TraditionalForm]],ExpressionUUID->
  "6aae751e-38d8-4953-867b-5863b83af9f4"],
 " in terms of ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalMu]", "+", "1"}], TraditionalForm]],ExpressionUUID->
  "9695c06c-b4ec-4727-8d09-f402312042ba"],
 " basis functions ",
 Cell[BoxData[
  FormBox["\[Phi]", TraditionalForm]],ExpressionUUID->
  "81dd4bd5-3e34-40e2-8c3d-0e0c557b5c29"],
 " corresponding to the ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalMu]", "+", "1"}], TraditionalForm]],ExpressionUUID->
  "43b2d63e-6d89-4612-9554-3a508721c906"],
 " unknown parameters. For polynomial basis functions, the number of \
parameters is one more than the order ",
 Cell[BoxData[
  FormBox["\[CapitalMu]", TraditionalForm]],ExpressionUUID->
  "ab13ff31-c2c7-47c2-8dd5-58fb42fbf222"],
 " of the polynomials. The basis functions can be anything, however: \
wavelets, Fourier components, etc.\n\nBishop (inexplicably) converts ",
 Cell[BoxData[
  FormBox[
   StyleBox["w",
    FontWeight->"Bold"], TraditionalForm]],ExpressionUUID->
  "2413a212-ea76-40c0-9640-4e8b71d6160d"],
 " into a covector and writes"
}], "Text",
 CellChangeTimes->{{3.728220906295454*^9, 3.728220946192494*^9}, {
   3.7282218953744383`*^9, 3.728221919178042*^9}, {3.728222933472761*^9, 
   3.728222989706678*^9}, {3.728223024410286*^9, 3.728223057641677*^9}, {
   3.72822435625596*^9, 3.728224387983367*^9}, 3.728251485977022*^9, 
   3.729119179755419*^9, {3.72916521124009*^9, 3.729165279052802*^9}, {
   3.7291823881914263`*^9, 3.7291824219583178`*^9}, {3.729644981843032*^9, 
   3.729644984372673*^9}, {3.729797791815206*^9, 
   3.72979787349229*^9}},ExpressionUUID->"0c885e1c-6623-47a5-a15d-\
b5a4815ad482"],

Cell[BoxData[
 FormBox[
  RowBox[{
   RowBox[{"y", "(", 
    RowBox[{
     StyleBox["x",
      FontWeight->"Bold"], 
     StyleBox[",",
      FontWeight->"Plain"], 
     StyleBox[" ",
      FontWeight->"Plain"], 
     StyleBox["w",
      FontWeight->"Bold"]}], 
    StyleBox[")",
     FontWeight->"Plain"]}], 
   StyleBox["=",
    FontWeight->"Plain"], 
   RowBox[{
    RowBox[{
     StyleBox["w",
      FontWeight->"Bold"], 
     StyleBox["\[Transpose]",
      FontWeight->"Plain"]}], 
    RowBox[{
     StyleBox["\[Phi]",
      FontWeight->"Bold"], 
     StyleBox["\[ThinSpace]",
      FontWeight->"Plain"], "(", 
     StyleBox["x",
      FontWeight->"Bold"], 
     StyleBox[")",
      FontWeight->"Plain"]}]}]}], TraditionalForm]], "DisplayFormula",
 CellChangeTimes->{{3.7282219448855343`*^9, 
  3.728222027597753*^9}},ExpressionUUID->"947be109-cf62-4de3-b545-\
15552e17c03f"],

Cell[TextData[{
 "where ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    StyleBox["\[Phi]",
     FontWeight->"Bold"], "\[ThinSpace]", "(", 
    StyleBox["x",
     FontWeight->"Bold"], ")"}], TraditionalForm]],ExpressionUUID->
  "7664d159-29b2-44e2-8792-094becf35ae2"],
 " is an ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{"\[CapitalMu]", "+", "1"}], ")"}], TraditionalForm]],
  ExpressionUUID->"2c7292a6-4c65-41e9-b006-06cbefd16de3"],
 "-dimensional column-vector of basis functions, the transpose of one row of \
our partials matrix ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "ed495fe0-6173-47f1-97f1-6ccd7a93693a"],
 ". We claim it\[CloseCurlyQuote]s better always to think of partials or \
gradients as values of differential forms, thus covectors (row vectors or \
covariant vectors, see ",
 ButtonBox["https://goo.gl/DkeVmM",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["https://goo.gl/DkeVmM"], None},
  ButtonNote->"https://goo.gl/DkeVmM"],
 ", ",
 ButtonBox["https://goo.gl/JgzqLR",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["https://goo.gl/JgzqLR"], None},
  ButtonNote->"https://goo.gl/JgzqLR"],
 ", and ",
 ButtonBox["https://goo.gl/4TcF4T",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["https://goo.gl/4TcF4T"], None},
  ButtonNote->"https://goo.gl/4TcF4T"],
 "). \n\nTo find best-fit values for ",
 Cell[BoxData[
  FormBox[
   StyleBox["w",
    FontWeight->"Bold"], TraditionalForm]],ExpressionUUID->
  "2e0cbb6f-7787-4b3a-9367-89d4bc1761dd"],
 ", rows of the partials matrix ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "4ef83fad-5c97-4ae5-98df-5042206ebc41"],
 " are the covector gradients of ",
 Cell[BoxData[
  FormBox["y", TraditionalForm]],ExpressionUUID->
  "c7e242fb-2722-4ae6-9a2b-3e2d84e871a3"],
 " with respect to ",
 Cell[BoxData[
  FormBox[
   StyleBox["w",
    FontWeight->"Bold"], TraditionalForm]],ExpressionUUID->
  "baff650f-684a-47d3-95c6-278ac2b4a93c"],
 ". We prefer to write"
}], "Text",
 CellChangeTimes->{{3.728222034989254*^9, 3.728222053237129*^9}, {
   3.728222178848859*^9, 3.7282222660799637`*^9}, {3.728222300000989*^9, 
   3.7282223904929523`*^9}, {3.7282228551572657`*^9, 3.728222859737496*^9}, {
   3.728223076788225*^9, 3.728223190463003*^9}, {3.728223230865528*^9, 
   3.728223361801167*^9}, 3.728223984636827*^9, {3.7282240554498873`*^9, 
   3.728224092328535*^9}, {3.728224400399331*^9, 3.728224741229491*^9}, {
   3.728224776796547*^9, 3.728224809363667*^9}, {3.7282517358200502`*^9, 
   3.7282517662896633`*^9}, {3.729091174357189*^9, 3.7290911785502853`*^9}, {
   3.729091212251935*^9, 3.729091219775629*^9}, {3.729091277188416*^9, 
   3.7290913266532917`*^9}, {3.72909268413879*^9, 3.729092706422126*^9}, {
   3.729119179778685*^9, 3.7291191797984324`*^9}, {3.729120346504904*^9, 
   3.7291203520894012`*^9}, {3.729165311843924*^9, 3.729165352537273*^9}, {
   3.7297978998390903`*^9, 
   3.7297979011646757`*^9}},ExpressionUUID->"c606c9be-2b65-497c-bd37-\
9ab63b1d0d1f"],

Cell[CellGroupData[{

Cell[TextData[{
 "observations as an ",
 Cell[BoxData[
  FormBox["\[CapitalNu]", TraditionalForm]],ExpressionUUID->
  "fcfdbf6a-2e88-4194-8eb9-62448305406d"],
 "-dimensional column-vector ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalZeta]", 
    RowBox[{"\[VeryThinSpace]", "\[CapitalNu]"}]], TraditionalForm]],
  ExpressionUUID->"7f371c41-2439-49ff-a405-bbbac410c97c"],
 " with elements ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Zeta]", 
    RowBox[{"\[VeryThinSpace]", 
     RowBox[{"j", "\[ThinSpace]", "\[Element]", "\[ThinSpace]", 
      RowBox[{"[", "\[ThinSpace]", 
       RowBox[{
        RowBox[{"1", "\[ThinSpace]", ".."}], "\[CapitalNu]"}], "\[ThinSpace]",
        "]"}]}]}]], TraditionalForm]],ExpressionUUID->
  "31127627-edad-47a8-807a-e6bbbe593f86"]
}], "Item",
 CellChangeTimes->{{3.728222034989254*^9, 3.728222053237129*^9}, {
   3.728222178848859*^9, 3.7282222660799637`*^9}, {3.728222300000989*^9, 
   3.7282223904929523`*^9}, {3.7282228551572657`*^9, 3.728222859737496*^9}, {
   3.728223076788225*^9, 3.728223190463003*^9}, {3.728223230865528*^9, 
   3.728223361801167*^9}, 3.728223984636827*^9, {3.7282240554498873`*^9, 
   3.728224092328535*^9}, {3.728224400399331*^9, 3.728224741229491*^9}, {
   3.728224776796547*^9, 3.728224809363667*^9}, {3.7282517358200502`*^9, 
   3.728251740048966*^9}, {3.728251771407675*^9, 3.728251772575143*^9}, {
   3.729029834166656*^9, 3.7290298371502934`*^9}, {3.72912036382929*^9, 
   3.7291203684585857`*^9}, {3.729645042322447*^9, 
   3.7296450425379868`*^9}},ExpressionUUID->"dd275c33-9123-49bb-8d04-\
f932e3ad2a1e"],

Cell[TextData[{
 "the model or unknown parameters, an ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{"\[CapitalMu]", "+", "1"}], ")"}], TraditionalForm]],
  ExpressionUUID->"34093d14-aa35-4214-a3e2-8b50e8957f15"],
 "-dimensional column-vector ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[CapitalXi]", 
    RowBox[{"\[ThinSpace]", 
     RowBox[{
      RowBox[{"(", 
       RowBox[{"\[CapitalMu]", "+", "1"}], ")"}], "\[Times]", "1"}]}]], 
   TraditionalForm]],ExpressionUUID->"27530d6a-94c4-4ec6-98d8-e68dfb593b21"],
 " with elements ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Xi]", 
    RowBox[{"\[ThinSpace]", 
     RowBox[{"i", "\[ThinSpace]", "\[Element]", "\[ThinSpace]", 
      RowBox[{"[", "\[ThinSpace]", 
       RowBox[{
        RowBox[{"0", "\[ThinSpace]", ".."}], "\[CapitalMu]"}], "\[ThinSpace]",
        "]"}]}]}]], TraditionalForm]],ExpressionUUID->
  "18943418-6c16-48be-9e34-aa1a1b321058"]
}], "Item",
 CellChangeTimes->{{3.728222034989254*^9, 3.728222053237129*^9}, {
   3.728222178848859*^9, 3.7282222660799637`*^9}, {3.728222300000989*^9, 
   3.7282223904929523`*^9}, {3.7282228551572657`*^9, 3.728222859737496*^9}, {
   3.728223076788225*^9, 3.728223190463003*^9}, {3.728223230865528*^9, 
   3.728223361801167*^9}, 3.728223984636827*^9, {3.7282240554498873`*^9, 
   3.728224092328535*^9}, {3.728224400399331*^9, 3.728224741229491*^9}, {
   3.728224776796547*^9, 3.728224809363667*^9}, {3.7282517358200502`*^9, 
   3.728251740048966*^9}, {3.728251771407675*^9, 3.7282517814515944`*^9}, {
   3.7282518993121*^9, 3.7282519004727907`*^9}, {3.729029844861236*^9, 
   3.72902984786119*^9}, {3.729120316833633*^9, 3.729120321664834*^9}, {
   3.729645058784465*^9, 3.729645058784536*^9}, {3.729797943877902*^9, 
   3.729797958453072*^9}},ExpressionUUID->"2948af39-64bd-4f21-92f5-\
546f15547f6c"],

Cell[TextData[{
 "partials matrix as ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["A", 
    RowBox[{"N", "\[Times]", 
     RowBox[{"(", 
      RowBox[{"\[CapitalMu]", "+", "1"}], ")"}]}]], TraditionalForm]],
  ExpressionUUID->"d3592327-6324-4fd1-8aca-3364bb7df57a"]
}], "Item",
 CellChangeTimes->{{3.728222034989254*^9, 3.728222053237129*^9}, {
   3.728222178848859*^9, 3.7282222660799637`*^9}, {3.728222300000989*^9, 
   3.7282223904929523`*^9}, {3.7282228551572657`*^9, 3.728222859737496*^9}, {
   3.728223076788225*^9, 3.728223190463003*^9}, {3.728223230865528*^9, 
   3.728223361801167*^9}, 3.728223984636827*^9, {3.7282240554498873`*^9, 
   3.728224092328535*^9}, {3.728224400399331*^9, 3.728224741229491*^9}, {
   3.728224776796547*^9, 3.728224809363667*^9}, {3.7282517358200502`*^9, 
   3.728251740048966*^9}, {3.728251771407675*^9, 3.728251789543252*^9}, {
   3.72825189594316*^9, 3.7282518961283197`*^9}, {3.729029865577499*^9, 
   3.7290298774959583`*^9}, {3.729797981334482*^9, 
   3.7297979898657427`*^9}},ExpressionUUID->"1a7d225e-8728-4deb-8507-\
28528fd81c64"]
}, Open  ]],

Cell[TextData[{
 "Bishop calls our partials matrix the ",
 StyleBox["design matrix",
  FontSlant->"Italic"],
 " in his equation 3.16, page 142, consisting of values of the basis \
functions at the concrete inputs ",
 Cell[BoxData[
  FormBox[
   SubscriptBox[
    StyleBox["x",
     FontWeight->"Bold"], 
    RowBox[{"n", "\[ThinSpace]", "\[Element]", "\[ThinSpace]", 
     RowBox[{"[", 
      RowBox[{
       RowBox[{"1", ".."}], "N"}], "]"}]}]], TraditionalForm]],
  ExpressionUUID->"d2561181-7429-4cc2-999c-7fe2b5f36bac"],
 ". Bishop must (more cumbersomely) work in the dual of our formulation. \n\n\
We prefer to write as follows: the covector rows of the design matrix terms \
as polynomial basis functions evaluated at the input points ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["x", 
    RowBox[{"n", "\[ThinSpace]", "\[Element]", "\[ThinSpace]", 
     RowBox[{"[", 
      RowBox[{
       RowBox[{"1", ".."}], "\[CapitalNu]"}], "]"}]}]], TraditionalForm]],
  ExpressionUUID->"c0cfc668-a741-4199-891b-2bde10b355d7"],
 ":"
}], "Text",
 CellChangeTimes->{{3.728222034989254*^9, 3.728222053237129*^9}, {
   3.728222178848859*^9, 3.7282222660799637`*^9}, {3.728222300000989*^9, 
   3.7282223904929523`*^9}, {3.7282228551572657`*^9, 3.728222859737496*^9}, {
   3.728223076788225*^9, 3.728223190463003*^9}, {3.728223230865528*^9, 
   3.728223361801167*^9}, 3.728223984636827*^9, {3.7282240554498873`*^9, 
   3.728224092328535*^9}, {3.728224400399331*^9, 3.728224741229491*^9}, {
   3.728224776796547*^9, 3.728224809363667*^9}, {3.7282517358200502`*^9, 
   3.728251740048966*^9}, {3.728251771407675*^9, 3.728251888355431*^9}, {
   3.729029892321496*^9, 3.729029983337439*^9}, {3.7291204222110157`*^9, 
   3.729120492782894*^9}, {3.7291653714940968`*^9, 3.729165462908938*^9}, {
   3.729182456005975*^9, 
   3.7291824795949993`*^9}},ExpressionUUID->"e56a234a-c338-4d71-95b0-\
1a2237f07f34"],

Cell[BoxData[
 FormBox[
  RowBox[{"Z", "  ", "=", "  ", 
   RowBox[{
    RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}], "  ", "=", "  ", 
    RowBox[{
     RowBox[{"(", GridBox[{
        {
         SubscriptBox["\[Zeta]", "0"]},
        {
         SubscriptBox["\[Zeta]", "1"]},
        {"\[VerticalEllipsis]"},
        {
         SubscriptBox["\[Zeta]", "\[CapitalNu]"]}
       }], ")"}], "  ", "=", "   ", 
     RowBox[{
      RowBox[{
       StyleBox[
        RowBox[{"(", GridBox[{
           {
            RowBox[{"1", "=", 
             SubsuperscriptBox["x", "1", "0"]}], 
            SubscriptBox["x", "1"], 
            SubsuperscriptBox["x", "1", "2"], "\[CenterEllipsis]", 
            SubsuperscriptBox["x", "1", "M"]},
           {
            RowBox[{"1", "=", 
             SubsuperscriptBox["x", "2", "0"]}], 
            SubscriptBox["x", "2"], 
            SubsuperscriptBox["x", "2", "2"], "\[CenterEllipsis]", 
            SubsuperscriptBox["x", "2", "M"]},
           {"\[VerticalEllipsis]", "\[VerticalEllipsis]", " ", 
            "\[DescendingEllipsis]", "\[VerticalEllipsis]"},
           {
            RowBox[{"1", "=", 
             SubsuperscriptBox["x", "N", "0"]}], 
            SubscriptBox["x", "N"], 
            SubsuperscriptBox["x", "N", "2"], "\[CenterEllipsis]", 
            SubsuperscriptBox["x", "N", "M"]}
          }], ")"}],
        FontWeight->"Plain"], "  ", "\[CenterDot]", "  ", 
       RowBox[{"(", GridBox[{
          {
           SubscriptBox["\[Xi]", "0"]},
          {
           SubscriptBox["\[Xi]", "1"]},
          {"\[VerticalEllipsis]"},
          {
           SubscriptBox["\[Xi]", "\[CapitalMu]"]}
         }], ")"}]}], "  ", "+", "  ", "noise"}]}]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.7282223267202578`*^9, 3.728222330771399*^9}, {
  3.728223414452943*^9, 3.728223474859379*^9}, {3.728223514299732*^9, 
  3.728223975929124*^9}, {3.728224109293193*^9, 3.728224109294752*^9}, {
  3.728224191499645*^9, 3.728224196666141*^9}, {3.728947752192189*^9, 
  3.728947823567884*^9}, {3.728949775673676*^9, 3.728949826088863*^9}, {
  3.729109560005604*^9, 3.72910969334587*^9}, {3.729109729502664*^9, 
  3.729109798273975*^9}, {3.729645085890316*^9, 
  3.729645106992324*^9}},ExpressionUUID->"28724abb-f182-4a4b-adef-\
e0815b06b267"],

Cell[TextData[{
 "then packed up into rows of the ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "867233d0-d313-41bb-ac38-e2b5260ac135"],
 " matrix. "
}], "Text",
 CellChangeTimes->{{3.729120500205209*^9, 
  3.729120518926064*^9}},ExpressionUUID->"63d79e64-ad79-4eab-8e8a-\
3dac9bf37b90"],

Cell[BoxData[
 FormBox[
  RowBox[{"Z", "  ", "=", "  ", 
   RowBox[{
    RowBox[{"A", "\[CenterDot]", "\[CapitalXi]"}], "  ", "=", "  ", 
    RowBox[{
     RowBox[{"(", GridBox[{
        {
         SubscriptBox["\[Zeta]", "0"]},
        {
         SubscriptBox["\[Zeta]", "1"]},
        {"\[VerticalEllipsis]"},
        {
         SubscriptBox["\[Zeta]", "\[CapitalNu]"]}
       }], ")"}], "  ", "=", "   ", 
     RowBox[{
      RowBox[{
       SubscriptBox[
        StyleBox[
         RowBox[{"(", GridBox[{
            {
             RowBox[{
              SubscriptBox[
               RowBox[{
                StyleBox["A",
                 FontWeight->"Plain"], 
                StyleBox["\[ThinSpace]",
                 FontWeight->"Bold"]}], 
               RowBox[{"1", "\[Times]", 
                RowBox[{"(", 
                 RowBox[{"\[CapitalMu]", "+", "1"}], ")"}]}]], 
              RowBox[{"(", 
               SubscriptBox["x", "1"], ")"}]}]},
            {
             RowBox[{
              SubscriptBox[
               RowBox[{
                StyleBox["A",
                 FontWeight->"Plain"], 
                StyleBox["\[ThinSpace]",
                 FontWeight->"Bold"]}], 
               RowBox[{"1", "\[Times]", 
                RowBox[{"(", 
                 RowBox[{"\[CapitalMu]", "+", "1"}], ")"}]}]], 
              RowBox[{"(", 
               SubscriptBox["x", "2"], ")"}]}]},
            {"\[VerticalEllipsis]"},
            {
             RowBox[{
              SubscriptBox[
               RowBox[{
                StyleBox["A",
                 FontWeight->"Plain"], 
                StyleBox["\[ThinSpace]",
                 FontWeight->"Bold"]}], 
               RowBox[{"1", "\[Times]", 
                RowBox[{"(", 
                 RowBox[{"\[CapitalMu]", "+", "1"}], ")"}]}]], 
              RowBox[{"(", 
               SubscriptBox["x", "\[CapitalNu]"], ")"}]}]}
           }], ")"}],
         FontWeight->"Plain"], 
        RowBox[{"\[CapitalNu]", "\[Times]", 
         RowBox[{"(", 
          RowBox[{"\[CapitalMu]", "+", "1"}], ")"}]}]], "  ", "\[CenterDot]", 
       "  ", 
       RowBox[{"(", GridBox[{
          {
           SubscriptBox["\[Xi]", "0"]},
          {
           SubscriptBox["\[Xi]", "1"]},
          {"\[VerticalEllipsis]"},
          {
           SubscriptBox["\[Xi]", "\[CapitalMu]"]}
         }], ")"}]}], "  ", "+", "  ", "noise"}]}]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.7282223267202578`*^9, 3.728222330771399*^9}, {
  3.728223414452943*^9, 3.728223474859379*^9}, {3.728223514299732*^9, 
  3.728223975929124*^9}, {3.728224109293193*^9, 3.728224109294752*^9}, {
  3.728224191499645*^9, 3.728224196666141*^9}, {3.728947752192189*^9, 
  3.728947823567884*^9}, {3.728949775673676*^9, 3.728949826088863*^9}, {
  3.7297980290173683`*^9, 
  3.729798052887404*^9}},ExpressionUUID->"c4a251c0-8d8d-4e74-8c68-\
ffaf8aa9cd31"]
}, Open  ]],

Cell[CellGroupData[{

Cell["MLE: The Normal Equations", "Subsection",
 CellChangeTimes->{{3.728251929759521*^9, 
  3.728251940262474*^9}},ExpressionUUID->"5f2495bd-b24f-45ea-b35c-\
1826a1fd64de"],

Cell["\<\
Mechanize the normal equations for comparison purposes; we expect them to \
over-fit.\
\>", "Text",
 CellChangeTimes->{{3.7279232272996387`*^9, 3.727923264174778*^9}, {
  3.727925248541918*^9, 3.7279252612235193`*^9}, {3.728219535976645*^9, 
  3.728219544909062*^9}, {3.728251418408484*^9, 3.728251422388431*^9}, {
  3.729024215377202*^9, 3.729024217223057*^9}, {3.729165197628982*^9, 
  3.729165198403118*^9}, {3.7291823464471197`*^9, 
  3.7291823613313932`*^9}},ExpressionUUID->"21b0dd02-714b-44f4-ac59-\
02773fa48214"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "mleFit", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"mleFit", "[", 
    RowBox[{"\[CapitalMu]_", ",", "trainingSet_"}], "]"}], ":=", 
   "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"xs", "=", 
        RowBox[{
        "trainingSet", "\[LeftDoubleBracket]", "1", 
         "\[RightDoubleBracket]"}]}], ",", 
       RowBox[{"ys", "=", 
        RowBox[{
        "trainingSet", "\[LeftDoubleBracket]", "2", 
         "\[RightDoubleBracket]"}]}]}], "}"}], ",", "\[IndentingNewLine]", 
     StyleBox[
      RowBox[{
       RowBox[{"PseudoInverse", "[", 
        RowBox[{"partialsFn", "[", 
         RowBox[{"\[CapitalMu]", ",", "xs"}], "]"}], "]"}], ".", "ys"}],
      Background->RGBColor[1, 1, 0]]}], "]"}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"mleFit", "[", 
  RowBox[{"3", ",", "bts"}], "]"}]}], "Input",
 CellChangeTimes->{{3.727885728192296*^9, 3.727885779639097*^9}, {
   3.727885809907544*^9, 3.727885814458734*^9}, {3.727886129093534*^9, 
   3.7278861410970383`*^9}, {3.72788617438813*^9, 3.7278862220128107`*^9}, {
   3.7278865585658693`*^9, 3.727886599363595*^9}, {3.7279031627619*^9, 
   3.727903227220593*^9}, {3.727913081988744*^9, 3.7279130820838013`*^9}, {
   3.727913123878634*^9, 3.727913123932819*^9}, {3.728090725899406*^9, 
   3.7280907259084253`*^9}, {3.728169613067173*^9, 3.728169613076036*^9}, 
   3.729175629972382*^9, {3.7291764342927237`*^9, 
   3.7291764366839447`*^9}},ExpressionUUID->"8a92f292-23d6-4b9f-857f-\
d8aefa40f0ef"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.039029332524661085`", ",", "9.614327858269638`", ",", 
   RowBox[{"-", "28.65737847115847`"}], ",", "18.979654255220883`"}], 
  "}"}]], "Output",
 CellChangeTimes->{
  3.7278862229627943`*^9, {3.727886559667815*^9, 3.727886599739743*^9}, {
   3.72790316911255*^9, 3.727903214869055*^9}, 3.7279033439958277`*^9, {
   3.727913077175877*^9, 3.727913082662711*^9}, 3.727913124658298*^9, 
   3.727915385897655*^9, 3.727915689226351*^9, 3.727918037352195*^9, 
   3.727918095083848*^9, 3.7279241986227837`*^9, {3.727927707553419*^9, 
   3.727927732702104*^9}, 3.727967810695971*^9, 3.727968733693976*^9, 
   3.7279698086933317`*^9, 3.727969955502687*^9, 3.728044352304865*^9, 
   3.728046448308305*^9, 3.728066470172489*^9, 3.72806812129386*^9, 
   3.728083784080934*^9, 3.728090742292589*^9, 3.72816944582929*^9, 
   3.728169541357428*^9, 3.728169823527856*^9, 3.728169883537332*^9, 
   3.728252956118902*^9, 3.7289462563501463`*^9, 3.729022900336874*^9, {
   3.729119979107937*^9, 3.729119996139695*^9}, 3.729121072645164*^9, 
   3.7291211111233273`*^9, 3.7291723080042467`*^9, 3.7291756909413757`*^9, 
   3.7291758020892*^9, 3.7291834127551937`*^9, {3.7291834480703287`*^9, 
   3.729183460969283*^9}, 3.729255937373231*^9, 3.729552301877532*^9, 
   3.729557876381481*^9, 3.7296298383478403`*^9, 3.729634636327812*^9, 
   3.729642872576435*^9, 3.7296429094051437`*^9, 3.7296439392773237`*^9, 
   3.729647185633141*^9, 3.7296832022663383`*^9, 3.7297781556886253`*^9, 
   3.729779233854649*^9, 3.7297792809555397`*^9, 3.729894700249802*^9, 
   3.729896006308855*^9, 
   3.729896152909051*^9},ExpressionUUID->"7d9f90d5-dbe2-4687-876c-\
d3f1bc1e87c1"]
}, Open  ]],

Cell["A convenience function:", "Text",
 CellChangeTimes->{{3.729798126892275*^9, 
  3.729798131955408*^9}},ExpressionUUID->"14fa37f8-7761-4b0c-a6d8-\
0ce6d583ed9e"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "symbolicPowers", "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"symbolicPowers", "[", 
    RowBox[{"variable_", ",", "order_"}], "]"}], ":=", "\[IndentingNewLine]", 
   
   RowBox[{
    RowBox[{"partialsFn", "[", 
     RowBox[{"order", ",", 
      RowBox[{"{", "variable", "}"}]}], "]"}], "\[LeftDoubleBracket]", "1", 
    "\[RightDoubleBracket]"}]}], ";"}]}], "Input",
 CellChangeTimes->{{3.7279153202694693`*^9, 3.727915371067972*^9}, {
  3.7279237255692472`*^9, 3.727923807685313*^9}, {3.729182514215464*^9, 
  3.729182515145398*^9}},ExpressionUUID->"a9e420a7-fe1c-47bd-8013-\
211fefd7186e"],

Cell["\<\
The normal equations as a symbolic polynomial. Notice we can increase the \
order beyond the number of data, creating an underdetermined system. This is \
not the typical case in real-world data processing. Usually the number of \
data exceed the order and the system is overdetermined. The pseudoinverse is \
agnostic to the distinction.\
\>", "Text",
 CellChangeTimes->{{3.728086616407036*^9, 3.728086644421227*^9}, {
  3.728167395574012*^9, 3.7281673997415857`*^9}, {3.728219572416009*^9, 
  3.728219595133831*^9}, {3.729645137300458*^9, 
  3.729645224959401*^9}},ExpressionUUID->"c2b4e56e-ae3e-417c-adc6-\
88d8b9431bf8"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "x", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"Manipulate", "[", "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"symbolicPowers", "[", 
     RowBox[{"x", ",", "\[CapitalMu]"}], "]"}], ".", 
    RowBox[{"mleFit", "[", 
     RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}], ",", 
   "\[IndentingNewLine]", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
      "\[CapitalMu]", ",", "3", ",", 
       "\"\<polynomial order \[CapitalMu]\>\""}], "}"}], ",", "0", ",", "16", 
     ",", "1", ",", 
     RowBox[{"Appearance", "\[Rule]", 
      RowBox[{"{", "\"\<Labeled\>\"", "}"}]}]}], "}"}]}], "]"}]}], "Input",
 CellChangeTimes->{{3.7280866505961733`*^9, 3.728086772996965*^9}, 
   3.728086803589117*^9, 3.728090725912261*^9, 3.7281696130841227`*^9, 
   3.7291756311754827`*^9, {3.729175826437456*^9, 
   3.7291758460147743`*^9}},ExpressionUUID->"40d44984-88b8-4065-93d5-\
cb6661f37f21"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`\[CapitalMu]$$ = 3, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`\[CapitalMu]$$], 3, "polynomial order \[CapitalMu]"},
       0, 16, 1}}, Typeset`size$$ = {405., {1., 16.}}, Typeset`update$$ = 0, 
    Typeset`initDone$$, Typeset`skipInitDone$$ = 
    True, $CellContext`\[CapitalMu]$2728$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`\[CapitalMu]$$ = 3}, 
      "ControllerVariables" :> {
        Hold[$CellContext`\[CapitalMu]$$, $CellContext`\[CapitalMu]$2728$$, 
         0]}, "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Dot[
        $CellContext`symbolicPowers[$CellContext`x, \
$CellContext`\[CapitalMu]$$], 
        $CellContext`mleFit[$CellContext`\[CapitalMu]$$, $CellContext`bts]], 
      "Specifications" :> {{{$CellContext`\[CapitalMu]$$, 3, 
          "polynomial order \[CapitalMu]"}, 0, 16, 1, 
         Appearance -> {"Labeled"}}}, "Options" :> {}, "DefaultOptions" :> {}],
     ImageSizeCache->{460., {60., 67.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.728086773562842*^9, 3.728086804275236*^9, 3.728090742426281*^9, 
   3.7281694459480057`*^9, 3.728169541460916*^9, 3.728169823628757*^9, 
   3.728169883652279*^9, 3.728225863858274*^9, 3.728252956249748*^9, 
   3.728946256894178*^9, 3.729022900437813*^9, {3.729119979237938*^9, 
   3.7291199962606564`*^9}, 3.729121072777959*^9, 3.729121111249694*^9, 
   3.7291723081374826`*^9, 3.729175691045731*^9, {3.729175810410253*^9, 
   3.729175846848763*^9}, 3.729182527081111*^9, 3.729183412855047*^9, {
   3.7291834481917963`*^9, 3.729183461081573*^9}, 3.729255937827094*^9, 
   3.729552301962193*^9, 3.729557876456039*^9, 3.729629838836141*^9, 
   3.7296346365430202`*^9, 3.729642872651252*^9, 3.729642909488571*^9, 
   3.7296439393563423`*^9, 3.729647185741205*^9, 3.729683202341844*^9, 
   3.729778155770583*^9, 3.7297792339418173`*^9, 3.729779281028274*^9, 
   3.7298947003399973`*^9, 3.729896006416829*^9, 
   3.7298961529887333`*^9},ExpressionUUID->"1d5bb5d2-9fee-4d7d-90b1-\
08c8eee7b15c"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["RLS: Recurrent Least Squares", "Subsection",
 CellChangeTimes->{{3.72825197766994*^9, 
  3.72825198556595*^9}},ExpressionUUID->"06f61c7b-bc70-40f6-9d67-\
5f09cca5a053"],

Cell[TextData[{
 "RLS is regularized by its a-priori estimate of the unknown parameters and \
its a-priori information matrix. Use the slider below to see that once the \
minimum info becomes too large, the \[CapitalLambda] matrix becomes \
ill-conditioned: pink warning message appear from the Wolfram kernel, and the \
solution is numerically suspect. In the rest of this paper, we eliminate \
these error message by applying Wolfram\[CloseCurlyQuote]s ",
 Cell[BoxData[
  FormBox["Quiet", TraditionalForm]], "Code",ExpressionUUID->
  "9b505f9f-26c0-4b35-9fff-cb61a0fb8312"],
 " because we notice, numerically, that ill-conditioning of the information \
matrix does not seem to be harmful."
}], "Text",
 CellChangeTimes->{{3.72792327800198*^9, 3.7279233078789587`*^9}, {
  3.7279713983804617`*^9, 3.72797140314161*^9}, {3.7280360936971283`*^9, 
  3.728036119472001*^9}, {3.728036163659585*^9, 3.728036240971705*^9}, {
  3.728219601486958*^9, 3.728219652487793*^9}, {3.728252003629099*^9, 
  3.7282520048359327`*^9}, {3.7291654907947273`*^9, 3.7291655087082767`*^9}, {
  3.729174198506338*^9, 3.729174199241322*^9}, {3.729182539373966*^9, 
  3.729182552706852*^9}, {3.729645241053973*^9, 3.72964531696039*^9}, {
  3.729798163505123*^9, 
  3.729798175666603*^9}},ExpressionUUID->"0c8046a6-3793-4992-8eef-\
7857084afc25"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "rlsFit", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{
     RowBox[{"rlsFit", "[", "\[Sigma]2\[CapitalLambda]_", "]"}], "[", 
     RowBox[{"\[CapitalMu]_", ",", "trainingSet_"}], "]"}], ":=", 
    "\[IndentingNewLine]", 
    RowBox[{"With", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"xs", "=", 
         RowBox[{
         "trainingSet", "\[LeftDoubleBracket]", "1", 
          "\[RightDoubleBracket]"}]}], ",", 
        RowBox[{"ys", "=", 
         RowBox[{
         "trainingSet", "\[LeftDoubleBracket]", "2", 
          "\[RightDoubleBracket]"}]}]}], "}"}], ",", "\[IndentingNewLine]", 
      RowBox[{"With", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{"\[Xi]0", "=", 
           RowBox[{"List", "/@", 
            RowBox[{"ConstantArray", "[", 
             RowBox[{"0", ",", 
              RowBox[{"\[CapitalMu]", "+", "1"}]}], "]"}]}]}], ",", 
          "\[IndentingNewLine]", 
          RowBox[{"\[CapitalLambda]0", "=", 
           RowBox[{"\[Sigma]2\[CapitalLambda]", "*", 
            RowBox[{"IdentityMatrix", "[", 
             RowBox[{"\[CapitalMu]", "+", "1"}], "]"}]}]}]}], "}"}], ",", 
        "\[IndentingNewLine]", 
        RowBox[{"Fold", "[", 
         RowBox[{"update", ",", 
          RowBox[{"{", 
           RowBox[{"\[Xi]0", ",", "\[CapitalLambda]0"}], "}"}], ",", 
          "\[IndentingNewLine]", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{"List", "/@", "ys"}], ",", 
             RowBox[{"List", "/@", 
              RowBox[{"partialsFn", "[", 
               RowBox[{"\[CapitalMu]", ",", "xs"}], "]"}]}]}], "}"}], 
           "\[Transpose]"}]}], "]"}]}], "]"}]}], "]"}]}], ";"}], 
  "\[IndentingNewLine]"}], "\[IndentingNewLine]", 
 RowBox[{"Manipulate", "[", "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{
     RowBox[{"rlsFit", "[", 
      SuperscriptBox["10", 
       RowBox[{"-", "log\[Sigma]2\[CapitalLambda]"}]], "]"}], "[", 
     RowBox[{"3", ",", "bts"}], "]"}], "\[LeftDoubleBracket]", "1", 
    "\[RightDoubleBracket]"}], ",", "\[IndentingNewLine]", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"log\[Sigma]2\[CapitalLambda]", ",", "9.034"}], "}"}], ",", "0",
      ",", "16", ",", 
     RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}]}], 
  "]"}]}], "Input",
 CellChangeTimes->{{3.727883299044437*^9, 3.727883408526169*^9}, {
   3.727883570679338*^9, 3.727883753730864*^9}, {3.727883800858717*^9, 
   3.727883838115073*^9}, {3.727883894473887*^9, 3.727884018340303*^9}, {
   3.72788406916578*^9, 3.727884157272581*^9}, {3.727884225392531*^9, 
   3.7278842277505903`*^9}, {3.7278843168329363`*^9, 
   3.7278844893030443`*^9}, {3.72788451944672*^9, 3.727884559637722*^9}, {
   3.727884601998887*^9, 3.727884641880664*^9}, {3.727884702205894*^9, 
   3.727884709112802*^9}, {3.727884840379463*^9, 3.727884840498255*^9}, {
   3.7279032520135508`*^9, 3.727903302618636*^9}, 3.7279033915207367`*^9, {
   3.727913089794886*^9, 3.727913129180463*^9}, {3.727923317022047*^9, 
   3.727923549746903*^9}, {3.727923650995542*^9, 3.727923655663189*^9}, 
   3.727923702873125*^9, {3.727923927853791*^9, 3.727923934334038*^9}, {
   3.727925310895234*^9, 3.727925333557376*^9}, {3.728036060877223*^9, 
   3.728036070969619*^9}, {3.7280362269856453`*^9, 3.72803623654352*^9}, {
   3.7280907259214077`*^9, 3.7280907259309683`*^9}, {3.728225889419126*^9, 
   3.728225889490087*^9}, {3.729173873480887*^9, 3.729173873491919*^9}, {
   3.729173952692565*^9, 3.729174033832899*^9}, {3.729174227557437*^9, 
   3.729174255702014*^9}, 3.729175632402956*^9, {3.729647132778007*^9, 
   3.729647148168085*^9}},ExpressionUUID->"321867e2-1653-4ec6-af92-\
6b562f33b3f5"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`log\[Sigma]2\[CapitalLambda]$$ = 9.034, 
    Typeset`show$$ = True, Typeset`bookmarkList$$ = {}, 
    Typeset`bookmarkMode$$ = "Menu", Typeset`animator$$, Typeset`animvar$$ = 
    1, Typeset`name$$ = "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`log\[Sigma]2\[CapitalLambda]$$], 9.034}, 0, 16}}, 
    Typeset`size$$ = {451., {4., 11.}}, Typeset`update$$ = 0, 
    Typeset`initDone$$, Typeset`skipInitDone$$ = 
    True, $CellContext`log\[Sigma]2\[CapitalLambda]$2792$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`log\[Sigma]2\[CapitalLambda]$$ = 9.034}, 
      "ControllerVariables" :> {
        Hold[$CellContext`log\[Sigma]2\[CapitalLambda]$$, $CellContext`log\
\[Sigma]2\[CapitalLambda]$2792$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Part[
        $CellContext`rlsFit[
        10^(-$CellContext`log\[Sigma]2\[CapitalLambda]$$)][
        3, $CellContext`bts], 1], 
      "Specifications" :> {{{$CellContext`log\[Sigma]2\[CapitalLambda]$$, 
          9.034}, 0, 16, Appearance -> "Labeled"}}, "Options" :> {}, 
      "DefaultOptions" :> {}],
     ImageSizeCache->{506., {60., 67.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{{3.727913103888098*^9, 3.7279131297094307`*^9}, 
   3.72791538595157*^9, 3.727915690618195*^9, 3.727918037406971*^9, 
   3.7279180951339293`*^9, 3.727923485679799*^9, {3.7279235212598963`*^9, 
   3.727923539397266*^9}, 3.727923656903368*^9, 3.727923703600333*^9, 
   3.7279240791268167`*^9, 3.7279241986997967`*^9, 3.727925360788505*^9, {
   3.727927707618471*^9, 3.7279277327546997`*^9}, 3.727967810771263*^9, 
   3.727968733807341*^9, 3.727969808755946*^9, 3.727969955556759*^9, {
   3.728036061824555*^9, 3.728036072918947*^9}, {3.7280362295589123`*^9, 
   3.7280362371095047`*^9}, 3.72804435235367*^9, 3.728046448406433*^9, 
   3.728066470986565*^9, 3.728068121352648*^9, 3.728083784580184*^9, 
   3.728090742542427*^9, 3.728169446059235*^9, 3.728169541523823*^9, 
   3.728169823744402*^9, 3.728169883754513*^9, {3.728225871308848*^9, 
   3.728225890298745*^9}, 3.728252956368375*^9, 3.728946256965219*^9, 
   3.7290229005394793`*^9, {3.729119979308299*^9, 3.729119996363627*^9}, 
   3.729121072861215*^9, 3.729121111350686*^9, 3.7291723082385883`*^9, 
   3.72917389958121*^9, {3.729174004154214*^9, 3.729174028000448*^9}, 
   3.729175691158844*^9, 3.729175854610073*^9, 3.729183412914186*^9, {
   3.729183448249649*^9, 3.729183461158495*^9}, 3.729255937922879*^9, 
   3.72955230200729*^9, 3.729557876515918*^9, 3.729629838903739*^9, 
   3.7296346366745358`*^9, 3.7296428727312737`*^9, 3.72964290955186*^9, 
   3.7296439394770603`*^9, 3.729646853151237*^9, 3.729647185826949*^9, 
   3.729683202415702*^9, 3.729778155827753*^9, 3.729779234003327*^9, 
   3.729779281093878*^9, 3.72989470041908*^9, 3.7298960064731913`*^9, 
   3.7298961530898743`*^9},ExpressionUUID->"3d513721-71b2-4687-b177-\
32cd68e63f3c"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["KAL: Foldable Kalman Filter", "Subsection",
 CellChangeTimes->{{3.728252019102867*^9, 3.728252024734199*^9}, {
  3.7290943120705023`*^9, 
  3.7290943137983313`*^9}},ExpressionUUID->"9eb483dd-0180-493c-a977-\
ac685cf1c40a"],

Cell[TextData[{
 "The foldable Kalman filter (KAL) follows below. This version has only the \
",
 StyleBox["update",
  FontSlant->"Italic"],
 " phase of a typical Kalman filter because the parameters-to-estimate are \
constant and there is no ",
 StyleBox["predict",
  FontSlant->"Italic"],
 " phase.\n\nNote the ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["P", "\[CapitalZeta]"], TraditionalForm]],ExpressionUUID->
  "944fe3ef-92a4-4716-82e3-d3bdcef1b832"],
 " parameter, the first in the definition of ",
 Cell[BoxData[
  FormBox["kalmanUpdate", TraditionalForm]], "Code",ExpressionUUID->
  "217ff7f6-5c5e-4f2d-b3fe-0e8e9924016d"],
 ". This is the ",
 StyleBox["covariance matrix of the observation noise",
  FontSlant->"Italic"],
 ". It is a constant throughout the folding run of the filter. That\
\[CloseCurlyQuote]s why it\[CloseCurlyQuote]s lambda-lifted into its own \
function slot; ",
 Cell[BoxData[
  FormBox["kalmanUpdate", TraditionalForm]], "Code",ExpressionUUID->
  "a6d93a7a-fed8-40bf-98a2-004f1bf9b537"],
 ", called with some concrete value of ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["P", "\[CapitalZeta]"], TraditionalForm]],ExpressionUUID->
  "87bdc418-bc3f-44b6-8a9a-fbee89c68b91"],
 ", yields a function that can be folded over an a-priori estimate ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Xi]", "0"], TraditionalForm]],ExpressionUUID->
  "2125d705-4d59-4364-b34e-6de72dbb8e08"],
 " and covariance ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["P", "0"], TraditionalForm]],ExpressionUUID->
  "cae5d4c1-22e1-4e7d-a1db-7c46cb34fc07"],
 " and a sequence of observation-and-partial-covector pairs ",
 Cell[BoxData[
  FormBox[
   RowBox[{"{", 
    RowBox[{"\[Zeta]", ",", "a"}], "}"}], TraditionalForm]],ExpressionUUID->
  "49799594-1382-4aab-87dd-b9fc92b25aa6"],
 "."
}], "Text",
 CellChangeTimes->{{3.727925392992813*^9, 3.727925440455097*^9}, {
  3.727968003304467*^9, 3.727968095322001*^9}, {3.727971415917358*^9, 
  3.727971445401681*^9}, {3.728167467247233*^9, 3.7281676104536*^9}, {
  3.7282196608402767`*^9, 3.728219713545024*^9}, {3.7282197580747232`*^9, 
  3.728219820377639*^9}, {3.728225898772212*^9, 3.7282259019302683`*^9}, {
  3.7282520355408773`*^9, 3.7282520676585073`*^9}, {3.728252107648376*^9, 
  3.7282521980434017`*^9}, {3.729030059987007*^9, 3.729030074977326*^9}, {
  3.729030986864485*^9, 3.7290310566698503`*^9}, {3.729092807796928*^9, 
  3.729092853441671*^9}, {3.729165528060895*^9, 3.729165730475572*^9}, {
  3.729174335777738*^9, 3.729174413265232*^9}, {3.7291825734673*^9, 
  3.729182599308608*^9}, {3.729638303220274*^9, 3.729638354229904*^9}, {
  3.729798208714859*^9, 
  3.729798263491578*^9}},ExpressionUUID->"838c6545-97a4-4160-9864-\
965a1cc36310"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{"kalmanUpdate", ",", "kalFit"}], "]"}], ";"}], "\n", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{
     RowBox[{
      StyleBox["kalmanUpdate",
       Background->RGBColor[1, 1, 0]], "[", "P\[CapitalZeta]_", "]"}], "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"\[Xi]_", ",", "P_"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"\[Zeta]_", ",", "a_"}], "}"}]}], "]"}], ":=", 
    "\[IndentingNewLine]", 
    RowBox[{"Module", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"D", ",", "KT", ",", "K", ",", "L"}], "}"}], ",", 
      "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"D", "=", 
        RowBox[{"P\[CapitalZeta]", "+", 
         RowBox[{"a", ".", "P", ".", 
          RowBox[{"a", "\[Transpose]"}]}]}]}], ";", "\[IndentingNewLine]", 
       RowBox[{"KT", "=", 
        RowBox[{"LinearSolve", "[", 
         RowBox[{"D", ",", 
          RowBox[{"a", ".", "P"}]}], "]"}]}], ";", 
       RowBox[{"K", "=", 
        RowBox[{"KT", "\[Transpose]"}]}], ";", "\[IndentingNewLine]", 
       RowBox[{"L", "=", 
        RowBox[{
         RowBox[{"IdentityMatrix", "[", 
          RowBox[{"Length", "[", "P", "]"}], "]"}], "-", 
         RowBox[{"K", ".", "a"}]}]}], ";", "\[IndentingNewLine]", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"\[Xi]", "+", 
          RowBox[{"K", ".", 
           RowBox[{"(", 
            RowBox[{"\[Zeta]", "-", 
             RowBox[{"a", ".", "\[Xi]"}]}], ")"}]}]}], ",", 
         RowBox[{"L", ".", "P"}]}], "}"}]}]}], "]"}]}], ";"}], 
  "\[IndentingNewLine]"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{"kalFit", "[", 
     RowBox[{"\[Sigma]\[Zeta]2_", ",", "\[Sigma]\[Xi]2_"}], "]"}], "[", 
    RowBox[{"order_", ",", "trainingSet_"}], "]"}], ":=", 
   "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"xs", "=", 
        RowBox[{
        "trainingSet", "\[LeftDoubleBracket]", "1", 
         "\[RightDoubleBracket]"}]}], ",", 
       RowBox[{"ys", "=", 
        RowBox[{
        "trainingSet", "\[LeftDoubleBracket]", "2", 
         "\[RightDoubleBracket]"}]}]}], "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"\[Xi]0", "=", 
          RowBox[{"List", "/@", 
           RowBox[{"ConstantArray", "[", 
            RowBox[{"0", ",", 
             RowBox[{"order", "+", "1"}]}], "]"}]}]}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"P0", "=", 
          RowBox[{"\[Sigma]\[Xi]2", "*", 
           RowBox[{"IdentityMatrix", "[", 
            RowBox[{"order", "+", "1"}], "]"}]}]}]}], "}"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"Fold", "[", 
        RowBox[{
         RowBox[{"kalmanUpdate", "[", 
          RowBox[{"\[Sigma]\[Zeta]2", "*", 
           RowBox[{"IdentityMatrix", "[", "1", "]"}]}], "]"}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"{", 
          RowBox[{"\[Xi]0", ",", "P0"}], "}"}], ",", "\[IndentingNewLine]", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{"List", "/@", "ys"}], ",", 
            RowBox[{"List", "/@", 
             RowBox[{"partialsFn", "[", 
              RowBox[{"order", ",", "xs"}], "]"}]}]}], "}"}], 
          "\[Transpose]"}]}], "]"}]}], "]"}]}], "]"}]}], ";"}]}], "Input",
 CellChangeTimes->{{3.727913455235773*^9, 3.727913522283977*^9}, 
   3.727913696290469*^9, {3.727913736480159*^9, 3.727913844376683*^9}, {
   3.727917392534089*^9, 3.727917436971686*^9}, {3.727917505035927*^9, 
   3.727917528745805*^9}, {3.727917565263034*^9, 3.727917689094305*^9}, {
   3.727917745897264*^9, 3.7279177578567343`*^9}, {3.727917794603846*^9, 
   3.727917832787274*^9}, 3.727917880971725*^9, {3.727917936171432*^9, 
   3.727918023146969*^9}, {3.727918153331463*^9, 3.727918275269082*^9}, {
   3.727918376669937*^9, 3.727918414049831*^9}, {3.727918508981811*^9, 
   3.727918529673747*^9}, {3.727918590013206*^9, 3.727918649485745*^9}, {
   3.727918701604838*^9, 3.727918748563583*^9}, {3.727919051486678*^9, 
   3.727919074926166*^9}, {3.7279191082942677`*^9, 3.7279191590963287`*^9}, {
   3.7279192864475107`*^9, 3.727919323121303*^9}, {3.727919354826254*^9, 
   3.727919508497794*^9}, {3.727919541340006*^9, 3.727919683877797*^9}, {
   3.727920118873128*^9, 3.7279202093625507`*^9}, {3.727921237681443*^9, 
   3.727921317118623*^9}, {3.7279213549874077`*^9, 3.727921369577837*^9}, {
   3.727921727194334*^9, 3.727921729479971*^9}, {3.727921764122665*^9, 
   3.727921833477203*^9}, {3.72792411169958*^9, 3.727924167792699*^9}, {
   3.72792422895082*^9, 3.727924231141032*^9}, {3.72792438065587*^9, 
   3.7279243990664377`*^9}, {3.727925449102767*^9, 3.7279255631525297`*^9}, {
   3.72792560570716*^9, 3.7279256061694813`*^9}, {3.7279681913170443`*^9, 
   3.727968211031343*^9}, 3.728167450131751*^9, {3.72816963059844*^9, 
   3.728169630606372*^9}, {3.728950036924389*^9, 3.728950066472802*^9}, {
   3.729165737473629*^9, 3.729165758394801*^9}, {3.729174264764344*^9, 
   3.729174321096059*^9}, {3.729638286474793*^9, 
   3.7296382904326887`*^9}},ExpressionUUID->"52c7028b-b963-44ab-bbc6-\
a0ee75a7e853"]
}, Open  ]],

Cell[CellGroupData[{

Cell["See All Three", "Subsection",
 CellChangeTimes->{{3.729094292024653*^9, 
  3.729094294711062*^9}},ExpressionUUID->"ce8fa48f-f674-4703-a6d9-\
8192c2b551c5"],

Cell[TextData[{
 "The following interactive demonstration shows ",
 Cell[BoxData[
  FormBox["mleFit", TraditionalForm]], "Code",ExpressionUUID->
  "4cb84eca-55a6-402e-87b6-60cd967b9f5b"],
 " (normal equations), ",
 Cell[BoxData[
  FormBox["rlsFit", TraditionalForm]], "Code",ExpressionUUID->
  "32d5863c-f1e1-40c4-9b5d-481484f253d0"],
 " (recurrent least squares), and ",
 Cell[BoxData[
  FormBox["kalFit", TraditionalForm]], "Code",ExpressionUUID->
  "1a3bf1c2-c6f4-4897-8186-d26fb9573d41"],
 " (Kalman folding) on Bishop\[CloseCurlyQuote]s training set.\n\nWhen the \
a-priori information matrix in RLS is ",
 Cell[BoxData[
  FormBox[
   SuperscriptBox["10", 
    RowBox[{"-", "6"}]], TraditionalForm]],ExpressionUUID->
  "f6fa54ad-2bf3-49fc-8f51-d6ac554275e8"],
 ", and when the a-priori covariance of the a-priori estimate in KAL is ",
 Cell[BoxData[
  FormBox[
   SuperscriptBox["10", "6"], TraditionalForm]],ExpressionUUID->
  "b5f6a42b-8214-43eb-b532-b23cb54f2a71"],
 ", both RLS and KAL produce regularized fits. In contrast, the MLE over-fits \
a ",
 Cell[BoxData[
  FormBox[
   SuperscriptBox["9", "th"], TraditionalForm]],ExpressionUUID->
  "df6e2ce4-ee21-4852-9304-c5350f92ab2f"],
 "-order polynomial by interpolating (going through) every data point because \
a ",
 Cell[BoxData[
  FormBox[
   SuperscriptBox["9", "th"], TraditionalForm]],ExpressionUUID->
  "6ea035c7-661b-4906-ba49-314a63a809b6"],
 "-order polynomial fits the ten data points exactly: the normal equations \
are neither overdetermined nor underdetermined at order nine, but \
accidentally constitute an exactly solvable linear system.\n\nIncreasing ",
 Cell[BoxData[
  FormBox[
   RowBox[{"-", "log\[CapitalLambda]"}], TraditionalForm]], "Code",
  ExpressionUUID->"61902d13-4626-4d5f-8830-5b0bd423956c"],
 " ",
 StyleBox["decreases",
  FontSlant->"Italic"],
 " the (magnitude of the) a-priori information matrix in RLS, meaning that we \
have less Bayesian belief in the a-priori estimate of the unknown parameters. \
Increasing ",
 Cell[BoxData[
  FormBox["log\[Sigma]\[Xi]2", TraditionalForm]], "Code",ExpressionUUID->
  "c17d11ea-e11e-4a64-bf08-fb5cc88187e6"],
 " ",
 StyleBox["increases",
  FontSlant->"Italic"],
 " the a-priori covariance of the estimate in KAL and similarly decreases \
belief in the a-priori estimate. They eventually both over-fit the data \
completely and align with MLE. Later, we show that MAP can be similarly made \
to over-fit. Run the polynomial order up to nine, then ",
 Cell[BoxData[
  FormBox[
   RowBox[{"-", "log\[CapitalLambda]"}], TraditionalForm]], "Code",
  ExpressionUUID->"a0f39e4c-2db3-415b-a534-44240dd6e6ec"],
 " and ",
 Cell[BoxData[
  FormBox["log\[Sigma]\[Xi]2", TraditionalForm]], "Code",ExpressionUUID->
  "2b542e52-8384-4059-9874-7f53c5d64849"],
 " all the way to the right, to their maximum values. "
}], "Text",
 CellChangeTimes->CompressedData["
1:eJxTTMoPSmViYGCQAWIQfaCLT7/k2GvHKzx3bEH0PolaVxBt5iYdDKIDOt0i
QLTdyT4wbSF2ZVE7kK4JkFwKojU5zN52AGnhJ8veg+jfpW1/QbSWyVvRTiBd
yTJPBkTf2tCjDaJ3tOy1A9GFa5lCQbSdaHw6iL4zUToLRHNflq0G0WmLzrWC
aGYVSfsukPsaTcH0q4NfJoDollU3F4Douicbzx4E0ge2dt4C0dPyd545AqRP
74XQq9knBr4G0gnbZdJAdN3uS7eYj792nByi/wxEP5vGuUoYSCtPzF4NomXs
pfdePAG058a9syB63amdhVeBdNM7CK0ib7AORN/0g9DXleO/gmgB/g4wrXC2
7cw1IJ39EUKr+rL8uAmk5ZQO/wLRKmKrY+8B6VNaG+NAtNvV2U93n3zt+HXS
p08g+t2N5T9AtM0tCG3hxDiF7dRrx6p6bTDNG7J9Fohe5WW3CEQDAASlAHc=

  "],ExpressionUUID->"4cf55009-8939-444f-a697-a490a12a616e"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Manipulate", "[", "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"Module", "[", 
    RowBox[{
     RowBox[{"{", "x", "}"}], ",", 
     RowBox[{"(*", " ", 
      RowBox[{"gensym", ":", " ", 
       RowBox[{"fresh", " ", "variable", " ", "name"}]}], " ", "*)"}], 
     "\[IndentingNewLine]", 
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", "\[IndentingNewLine]", 
        RowBox[{
         RowBox[{"terms", "=", 
          RowBox[{"symbolicPowers", "[", 
           RowBox[{"x", ",", "\[CapitalMu]"}], "]"}]}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"cs", "=", 
          RowBox[{
           RowBox[{"\[Phi]", "[", "\[CapitalMu]", "]"}], "/@", 
           RowBox[{"List", "/@", 
            RowBox[{
            "bts", "\[LeftDoubleBracket]", "1", 
             "\[RightDoubleBracket]"}]}]}]}]}], "}"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"With", "[", 
        RowBox[{
         RowBox[{"{", "\[IndentingNewLine]", 
          RowBox[{
           RowBox[{"recurrent", "=", 
            RowBox[{"Quiet", "@", 
             RowBox[{
              RowBox[{"rlsFit", "[", 
               SuperscriptBox["10", 
                RowBox[{"-", "log\[CapitalLambda]0"}]], "]"}], "[", 
              RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}]}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"normal", "=", 
            RowBox[{"mleFit", "[", 
             RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"kalman", "=", 
            RowBox[{
             RowBox[{"kalFit", "[", 
              RowBox[{
               SuperscriptBox["bishopFakeSigma", "2"], ",", 
               SuperscriptBox["10", "log\[Sigma]\[Xi]2"]}], "]"}], "[", 
             RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}]}], "}"}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"With", "[", 
          RowBox[{
           RowBox[{"{", "\[IndentingNewLine]", 
            RowBox[{
             RowBox[{"rlsFn", "=", 
              RowBox[{
               RowBox[{"{", "terms", "}"}], ".", 
               RowBox[{
               "recurrent", "\[LeftDoubleBracket]", "1", 
                "\[RightDoubleBracket]"}]}]}], ",", "\[IndentingNewLine]", 
             RowBox[{"mleFn", "=", 
              RowBox[{"terms", ".", "normal"}]}], ",", "\[IndentingNewLine]", 
             
             RowBox[{"kalFn", "=", 
              RowBox[{
               RowBox[{"{", "terms", "}"}], ".", 
               RowBox[{
               "kalman", "\[LeftDoubleBracket]", "1", 
                "\[RightDoubleBracket]"}]}]}]}], "}"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"With", "[", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"lp", "=", 
               RowBox[{"ListPlot", "[", 
                RowBox[{
                 RowBox[{"bts", "\[Transpose]"}], ",", "\[IndentingNewLine]", 
                 
                 RowBox[{"PlotMarkers", "\[Rule]", 
                  RowBox[{"{", 
                   RowBox[{
                    RowBox[{"Graphics", "@", 
                    RowBox[{"{", 
                    RowBox[{"Blue", ",", 
                    RowBox[{"Circle", "[", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"0", ",", "0"}], "}"}], ",", "1"}], "]"}]}], 
                    "}"}]}], ",", ".05"}], "}"}]}]}], "]"}]}], "}"}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{"Module", "[", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"showlist", "=", 
                 RowBox[{"{", 
                  RowBox[{"lp", ",", 
                   RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox[
                    RowBox[{"Sin", "[", 
                    RowBox[{"2.", "\[Pi]", " ", "x"}], "]"}],
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0.", ",", "1."}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"Thick", ",", 
                    StyleBox["Green",
                    Background->RGBColor[1, 1, 0]]}], "}"}]}]}], "]"}]}], 
                  "}"}]}], "}"}], ",", "\[IndentingNewLine]", 
               RowBox[{
                RowBox[{"If", "[", 
                 RowBox[{"rlsQ", ",", 
                  RowBox[{"AppendTo", "[", 
                   RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["rlsFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Purple",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                   "]"}]}], "]"}], ";", "\[IndentingNewLine]", 
                RowBox[{"If", "[", 
                 RowBox[{"mleQ", ",", 
                  RowBox[{"AppendTo", "[", 
                   RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["mleFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Orange",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                   "]"}]}], "]"}], ";", "\[IndentingNewLine]", 
                RowBox[{"If", "[", 
                 RowBox[{"kalQ", ",", 
                  RowBox[{"AppendTo", "[", 
                   RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["kalFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Cyan",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                   "]"}]}], "]"}], ";", "\[IndentingNewLine]", 
                RowBox[{"Quiet", "@", 
                 RowBox[{"Show", "[", 
                  RowBox[{"showlist", ",", 
                   RowBox[{"Frame", "\[Rule]", "True"}], ",", 
                   RowBox[{"FrameLabel", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"\"\<x\>\"", ",", "\"\<t\>\""}], "}"}]}]}], 
                  "]"}]}]}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}], 
    "]"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Grid", "[", 
    RowBox[{"{", "\[IndentingNewLine]", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"Grid", "[", 
        RowBox[{"{", 
         RowBox[{"{", "\[IndentingNewLine]", 
          RowBox[{
           RowBox[{"Button", "[", 
            RowBox[{"\"\<RESET\>\"", ",", 
             RowBox[{
              RowBox[{"(", 
               RowBox[{
                RowBox[{"\[CapitalMu]", "=", "9"}], ";", 
                RowBox[{"log\[CapitalLambda]0", "=", "3"}], ";", 
                RowBox[{"log\[Sigma]\[Xi]2", "=", "3"}]}], ")"}], "&"}]}], 
            "]"}], ",", "\[IndentingNewLine]", 
           RowBox[{"Control", "[", 
            RowBox[{"{", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"rlsQ", ",", "True", ",", "\"\<RLS\>\""}], "}"}], ",", 
              
              RowBox[{"{", 
               RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"Control", "[", 
            RowBox[{"{", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"kalQ", ",", "True", ",", "\"\<KAL\>\""}], "}"}], ",", 
              
              RowBox[{"{", 
               RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"Control", "[", 
            RowBox[{"{", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"mleQ", ",", "True", ",", "\"\<MLE\>\""}], "}"}], ",", 
              
              RowBox[{"{", 
               RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}]}], "}"}],
          "}"}], "]"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"Control", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
           "\[CapitalMu]", ",", "9", ",", "\"\<polynomial order\>\""}], "}"}],
           ",", "0", ",", "16", ",", "1", ",", 
          RowBox[{"Appearance", "\[Rule]", 
           RowBox[{"{", "\"\<Labeled\>\"", "}"}]}]}], "}"}], "]"}], "}"}], 
      ",", 
      RowBox[{"{", 
       RowBox[{"Control", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
           "log\[CapitalLambda]0", ",", "3", ",", 
            "\"\<-log a-priori info (RLS)\>\""}], "}"}], ",", "0", ",", "16", 
          ",", 
          RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], 
        "]"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"Control", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
           "log\[Sigma]\[Xi]2", ",", "3", ",", 
            "\"\<log a-priori cov (KAL)\>\""}], "}"}], ",", "0", ",", "16", 
          ",", 
          RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], 
        "]"}], "}"}]}], "}"}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.727884681931381*^9, 3.7278848244947367`*^9}, 
   3.727884861217602*^9, {3.727884975910451*^9, 3.7278849940673532`*^9}, {
   3.727885103521431*^9, 3.727885154698123*^9}, {3.72788520225443*^9, 
   3.727885279820177*^9}, {3.727885496115718*^9, 3.727885517688189*^9}, {
   3.72788559395383*^9, 3.727885598972475*^9}, {3.7278856296542664`*^9, 
   3.727885630876935*^9}, {3.727885695972756*^9, 3.727885696864628*^9}, {
   3.727886633660364*^9, 3.72788671287046*^9}, {3.727886975364171*^9, 
   3.727886975439041*^9}, {3.727903476653379*^9, 3.7279034819231358`*^9}, {
   3.727903531862627*^9, 3.727903539245574*^9}, 3.727913149489944*^9, {
   3.727915429732944*^9, 3.7279154437948627`*^9}, {3.727915750998211*^9, 
   3.7279158447033873`*^9}, {3.7279213832695303`*^9, 3.72792149154887*^9}, {
   3.727921523149373*^9, 3.72792161270367*^9}, {3.72792165300301*^9, 
   3.727921654632832*^9}, {3.727921753282296*^9, 3.727921753360197*^9}, {
   3.727924008558401*^9, 3.727924045018003*^9}, {3.727924293814445*^9, 
   3.727924370827516*^9}, 3.727965590613636*^9, {3.7279686551525917`*^9, 
   3.727968670349081*^9}, {3.7279689406605043`*^9, 3.727969019631563*^9}, {
   3.727970883056108*^9, 3.727970945128386*^9}, {3.727971005813472*^9, 
   3.727971023734253*^9}, {3.727990640753121*^9, 3.727990674786282*^9}, {
   3.727990711779483*^9, 3.727990808626033*^9}, {3.727991307012423*^9, 
   3.727991307022031*^9}, {3.7279932412769613`*^9, 3.7279932949280367`*^9}, {
   3.7279933910397243`*^9, 3.727993398358789*^9}, {3.727993778490755*^9, 
   3.72799379332897*^9}, {3.727993826040863*^9, 3.7279938751552763`*^9}, {
   3.727993956673335*^9, 3.727993958184173*^9}, 3.727994128012043*^9, {
   3.7280354067714148`*^9, 3.7280354258611927`*^9}, {3.728035634299762*^9, 
   3.728035732029833*^9}, {3.72803585641748*^9, 3.728035906176405*^9}, {
   3.728038924314391*^9, 3.728039041653799*^9}, {3.728039077026232*^9, 
   3.72803913265169*^9}, {3.728039194847865*^9, 3.728039320044661*^9}, {
   3.728044256958378*^9, 3.728044343151896*^9}, {3.728044393583234*^9, 
   3.728044466540698*^9}, 3.7280447095836163`*^9, {3.728044856722988*^9, 
   3.728044959527645*^9}, {3.728044995179022*^9, 3.728044998104682*^9}, {
   3.728045028753289*^9, 3.728045063548128*^9}, {3.728045464570526*^9, 
   3.728045476328084*^9}, {3.728045812340419*^9, 3.728045836978776*^9}, {
   3.7280461335391397`*^9, 3.728046355530389*^9}, {3.728046392282709*^9, 
   3.728046397281275*^9}, {3.728046429888109*^9, 3.728046434285967*^9}, {
   3.728046509047914*^9, 3.728046577986915*^9}, {3.728048625582951*^9, 
   3.728048658147644*^9}, {3.728048704639155*^9, 3.7280487209829884`*^9}, {
   3.728048763333255*^9, 3.728048783520523*^9}, 3.728048849900649*^9, {
   3.728048881350296*^9, 3.7280488887365723`*^9}, {3.7280489358794527`*^9, 
   3.728048947834031*^9}, {3.7280492952517767`*^9, 3.728049427179392*^9}, {
   3.728049506853256*^9, 3.7280496162697783`*^9}, {3.728049702949929*^9, 
   3.728049708359687*^9}, {3.7280497561537037`*^9, 3.728049819625853*^9}, {
   3.728049930158724*^9, 3.728049930640306*^9}, {3.728089854705469*^9, 
   3.728089855621914*^9}, {3.728090725808407*^9, 3.7280907258189697`*^9}, {
   3.728169349695664*^9, 3.728169349720875*^9}, {3.7281694009815397`*^9, 
   3.7281694178910418`*^9}, {3.728169511786654*^9, 3.7281695237214537`*^9}, {
   3.728169612536371*^9, 3.728169630625689*^9}, 3.72825398263583*^9, {
   3.729093231337966*^9, 3.729093231816064*^9}, {3.729119276943676*^9, 
   3.729119308121522*^9}, {3.7291200359185753`*^9, 3.729120071022612*^9}, {
   3.729120620963278*^9, 3.729120653409905*^9}, {3.729120691319798*^9, 
   3.729120728301819*^9}, {3.729173389813801*^9, 3.729173389829308*^9}, {
   3.729173873512885*^9, 3.729173873529933*^9}, {3.7291744772483892`*^9, 
   3.7291744951446943`*^9}, {3.7291745287743883`*^9, 3.729174572901572*^9}, {
   3.729175490403535*^9, 3.7291755161637173`*^9}, {3.729175633605082*^9, 
   3.729175638831461*^9}, {3.729183394512477*^9, 
   3.729183394521019*^9}},ExpressionUUID->"3a5fce84-880e-478b-8c46-\
78e94eac9275"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`kalQ$$ = 
    True, $CellContext`log\[CapitalLambda]0$$ = 
    3, $CellContext`log\[Sigma]\[Xi]2$$ = 3, $CellContext`mleQ$$ = 
    True, $CellContext`rlsQ$$ = True, $CellContext`\[CapitalMu]$$ = 9, 
    Typeset`show$$ = True, Typeset`bookmarkList$$ = {}, 
    Typeset`bookmarkMode$$ = "Menu", Typeset`animator$$, Typeset`animvar$$ = 
    1, Typeset`name$$ = "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`rlsQ$$], True, "RLS"}, {True, False}}, {{
       Hold[$CellContext`kalQ$$], True, "KAL"}, {True, False}}, {{
       Hold[$CellContext`mleQ$$], True, "MLE"}, {True, False}}, {{
       Hold[$CellContext`\[CapitalMu]$$], 9, "polynomial order"}, 0, 16, 1}, {{
       Hold[$CellContext`log\[CapitalLambda]0$$], 3, 
       "-log a-priori info (RLS)"}, 0, 16}, {{
       Hold[$CellContext`log\[Sigma]\[Xi]2$$], 3, "log a-priori cov (KAL)"}, 
      0, 16}, {
      Hold[
       Grid[{{
          Grid[{{
             Button[
             "RESET", ($CellContext`\[CapitalMu]$$ = 
               9; $CellContext`log\[CapitalLambda]0$$ = 
               3; $CellContext`log\[Sigma]\[Xi]2$$ = 3)& ], 
             Manipulate`Place[1], 
             Manipulate`Place[2], 
             Manipulate`Place[3]}}]}, {
          Manipulate`Place[4]}, {
          Manipulate`Place[5]}, {
          Manipulate`Place[6]}}]], Manipulate`Dump`ThisIsNotAControl}}, 
    Typeset`size$$ = {450., {141., 147.}}, Typeset`update$$ = 0, 
    Typeset`initDone$$, Typeset`skipInitDone$$ = 
    True, $CellContext`rlsQ$2815$$ = False, $CellContext`kalQ$2816$$ = 
    False, $CellContext`mleQ$2817$$ = 
    False, $CellContext`\[CapitalMu]$2818$$ = 
    0, $CellContext`log\[CapitalLambda]0$2819$$ = 
    0, $CellContext`log\[Sigma]\[Xi]2$2820$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     2, StandardForm, 
      "Variables" :> {$CellContext`kalQ$$ = 
        True, $CellContext`log\[CapitalLambda]0$$ = 
        3, $CellContext`log\[Sigma]\[Xi]2$$ = 3, $CellContext`mleQ$$ = 
        True, $CellContext`rlsQ$$ = True, $CellContext`\[CapitalMu]$$ = 9}, 
      "ControllerVariables" :> {
        Hold[$CellContext`rlsQ$$, $CellContext`rlsQ$2815$$, False], 
        Hold[$CellContext`kalQ$$, $CellContext`kalQ$2816$$, False], 
        Hold[$CellContext`mleQ$$, $CellContext`mleQ$2817$$, False], 
        Hold[$CellContext`\[CapitalMu]$$, $CellContext`\[CapitalMu]$2818$$, 
         0], 
        Hold[$CellContext`log\[CapitalLambda]0$$, $CellContext`log\
\[CapitalLambda]0$2819$$, 0], 
        Hold[$CellContext`log\[Sigma]\[Xi]2$$, \
$CellContext`log\[Sigma]\[Xi]2$2820$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Module[{$CellContext`x$}, 
        With[{$CellContext`terms$ = \
$CellContext`symbolicPowers[$CellContext`x$, $CellContext`\[CapitalMu]$$], \
$CellContext`cs$ = Map[
            $CellContext`\[Phi][$CellContext`\[CapitalMu]$$], 
            Map[List, 
             Part[$CellContext`bts, 1]]]}, 
         With[{$CellContext`recurrent$ = Quiet[
             $CellContext`rlsFit[
             10^(-$CellContext`log\[CapitalLambda]0$$)][$CellContext`\
\[CapitalMu]$$, $CellContext`bts]], $CellContext`normal$ = \
$CellContext`mleFit[$CellContext`\[CapitalMu]$$, $CellContext`bts], \
$CellContext`kalman$ = $CellContext`kalFit[$CellContext`bishopFakeSigma^2, 
             10^$CellContext`log\[Sigma]\[Xi]2$$][$CellContext`\[CapitalMu]$$,\
 $CellContext`bts]}, 
          With[{$CellContext`rlsFn$ = Dot[{$CellContext`terms$}, 
              Part[$CellContext`recurrent$, 1]], $CellContext`mleFn$ = 
            Dot[$CellContext`terms$, $CellContext`normal$], \
$CellContext`kalFn$ = Dot[{$CellContext`terms$}, 
              Part[$CellContext`kalman$, 1]]}, 
           With[{$CellContext`lp$ = ListPlot[
               Transpose[$CellContext`bts], PlotMarkers -> {
                 Graphics[{Blue, 
                   Circle[{0, 0}, 1]}], 0.05}]}, 
            Module[{$CellContext`showlist$ = {$CellContext`lp$, 
                Plot[
                 Sin[2. Pi $CellContext`x$], {$CellContext`x$, 0., 1.}, 
                 PlotStyle -> {Thick, Green}]}}, If[$CellContext`rlsQ$$, 
               AppendTo[$CellContext`showlist$, 
                
                Plot[$CellContext`rlsFn$, {$CellContext`x$, 0, 1}, 
                 PlotStyle -> {Purple}]]]; If[$CellContext`mleQ$$, 
               AppendTo[$CellContext`showlist$, 
                
                Plot[$CellContext`mleFn$, {$CellContext`x$, 0, 1}, 
                 PlotStyle -> {Orange}]]]; If[$CellContext`kalQ$$, 
               AppendTo[$CellContext`showlist$, 
                
                Plot[$CellContext`kalFn$, {$CellContext`x$, 0, 1}, 
                 PlotStyle -> {Cyan}]]]; Quiet[
               
               Show[$CellContext`showlist$, Frame -> True, 
                FrameLabel -> {"x", "t"}]]]]]]]], 
      "Specifications" :> {{{$CellContext`rlsQ$$, True, "RLS"}, {True, False},
          ControlPlacement -> 1}, {{$CellContext`kalQ$$, True, "KAL"}, {
         True, False}, ControlPlacement -> 
         2}, {{$CellContext`mleQ$$, True, "MLE"}, {True, False}, 
         ControlPlacement -> 
         3}, {{$CellContext`\[CapitalMu]$$, 9, "polynomial order"}, 0, 16, 1, 
         Appearance -> {"Labeled"}, ControlPlacement -> 
         4}, {{$CellContext`log\[CapitalLambda]0$$, 3, 
          "-log a-priori info (RLS)"}, 0, 16, Appearance -> "Labeled", 
         ControlPlacement -> 
         5}, {{$CellContext`log\[Sigma]\[Xi]2$$, 3, "log a-priori cov (KAL)"},
          0, 16, Appearance -> "Labeled", ControlPlacement -> 6}, 
        Grid[{{
           Grid[{{
              Button[
              "RESET", ($CellContext`\[CapitalMu]$$ = 
                9; $CellContext`log\[CapitalLambda]0$$ = 
                3; $CellContext`log\[Sigma]\[Xi]2$$ = 3)& ], 
              Manipulate`Place[1], 
              Manipulate`Place[2], 
              Manipulate`Place[3]}}]}, {
           Manipulate`Place[4]}, {
           Manipulate`Place[5]}, {
           Manipulate`Place[6]}}]}, "Options" :> {}, "DefaultOptions" :> {}],
     ImageSizeCache->{505., {244., 251.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.729120694893572*^9, 3.729120729239387*^9, 3.729121073140068*^9, 
   3.729121111649043*^9, 3.729172308359383*^9, 3.729174504534432*^9, 
   3.729174541120797*^9, 3.729174577438936*^9, 3.7291756912669277`*^9, 
   3.729175878038041*^9, 3.729183413008506*^9, {3.729183448351598*^9, 
   3.729183461260701*^9}, 3.7292559380417747`*^9, 3.7295523020803957`*^9, 
   3.729557876588092*^9, 3.729629838965455*^9, 3.729634637046328*^9, 
   3.7296428728365097`*^9, 3.729642909628141*^9, 3.729643939586529*^9, 
   3.72964718593789*^9, 3.7296832025410233`*^9, 3.729778155948976*^9, 
   3.7297792341062117`*^9, 3.729779281194851*^9, 3.729894700523287*^9, 
   3.7298960065802193`*^9, 
   3.729896153198247*^9},ExpressionUUID->"ded1f429-ae28-4582-834e-\
2bfd46f9b682"]
}, Open  ]]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Renormalizing RLS", "Subchapter",
 CellChangeTimes->{{3.729092768444851*^9, 3.729092782412208*^9}, {
  3.729191699611701*^9, 3.729191706169241*^9}, {3.729798432235529*^9, 
  3.7297984335852747`*^9}},ExpressionUUID->"5f346f92-37a2-4867-8d13-\
e9fb4fd1ac60"],

Cell[TextData[{
 "When the observation noise ",
 Cell[BoxData[
  FormBox["\[CapitalZeta]", TraditionalForm]],ExpressionUUID->
  "cee2b76b-94f4-4d39-af2d-0579b6076db6"],
 " is unity, KAL coincides with RLS. In the demonstration below, a-priori \
information ",
 Cell[BoxData[
  FormBox["\[CapitalLambda]", TraditionalForm]],ExpressionUUID->
  "64b2c5a6-569c-42ea-9d39-1c5b1e4d462c"],
 " in RLS is set always to be the inverse of a-priori estimate covariance ",
 Cell[BoxData[
  FormBox["P", TraditionalForm]],ExpressionUUID->
  "0c6f3956-3d95-4cf6-a9d1-9ca1c9fcb773"],
 " in KAL; RLS and KAL will have the same belief in the a-priori estimate of \
the unknown parameters. Vary the observation noise independently to see KAL \
and RLS coincide when it\[CloseCurlyQuote]s zero.\n\nAs observation noise \
decreases, the solutions believe the observations more and the solution \
over-fits. As the a-priori covariance decreases, the solution believes the \
a-priori estimates more and the solution regularizes."
}], "Text",
 CellChangeTimes->{{3.729093282411186*^9, 3.729093313683037*^9}, {
   3.729117959440587*^9, 3.729117962326047*^9}, {3.7291180366585493`*^9, 
   3.7291181529404573`*^9}, {3.729120823468717*^9, 3.7291208319067087`*^9}, {
   3.729120924129122*^9, 3.7291209334511013`*^9}, {3.7291612546720057`*^9, 
   3.7291614312105837`*^9}, {3.729161481669347*^9, 3.729161524300392*^9}, {
   3.729165948834399*^9, 3.7291660151159143`*^9}, 3.7291746302654448`*^9, 
   3.729174660835752*^9, {3.729182703813655*^9, 3.7291827056457043`*^9}, {
   3.729645533347239*^9, 3.729645535008542*^9}, {3.72968376925354*^9, 
   3.729683796986575*^9}, {3.72968383611133*^9, 3.729683840551021*^9}, {
   3.7296873492799683`*^9, 3.7296874288640547`*^9}, {3.729798450427746*^9, 
   3.729798491548514*^9}},ExpressionUUID->"755d7272-a91b-4e07-b81c-\
0a073922e997"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Manipulate", "[", 
  RowBox[{
   RowBox[{"Module", "[", 
    RowBox[{
     RowBox[{"{", "x", "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"terms", "=", 
          RowBox[{"symbolicPowers", "[", 
           RowBox[{"x", ",", "\[CapitalMu]"}], "]"}]}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"cs", "=", 
          RowBox[{
           RowBox[{"\[Phi]", "[", "\[CapitalMu]", "]"}], "/@", 
           RowBox[{"List", "/@", 
            RowBox[{
            "bts", "\[LeftDoubleBracket]", "1", 
             "\[RightDoubleBracket]"}]}]}]}]}], "}"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"With", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"rls", "=", 
            RowBox[{"Quiet", "@", 
             RowBox[{
              RowBox[{"rlsFit", "[", 
               SuperscriptBox["10", 
                RowBox[{
                 RowBox[{"-", "2"}], "log\[Sigma]\[Xi]"}]], "]"}], "[", 
              RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}]}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"kalman", "=", 
            RowBox[{
             RowBox[{"kalFit", "[", 
              RowBox[{
               SuperscriptBox["10", 
                RowBox[{"2", "log\[Sigma]\[Zeta]"}]], ",", 
               SuperscriptBox["10", 
                RowBox[{"2", "log\[Sigma]\[Xi]"}]]}], "]"}], "[", 
             RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}]}], "}"}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"With", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{"rlsFn", "=", 
              RowBox[{
               RowBox[{"{", "terms", "}"}], ".", 
               RowBox[{
               "rls", "\[LeftDoubleBracket]", "1", 
                "\[RightDoubleBracket]"}]}]}], ",", "\[IndentingNewLine]", 
             RowBox[{"kalFn", "=", 
              RowBox[{
               RowBox[{"{", "terms", "}"}], ".", 
               RowBox[{
               "kalman", "\[LeftDoubleBracket]", "1", 
                "\[RightDoubleBracket]"}]}]}]}], "}"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"With", "[", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"lp", "=", 
               RowBox[{"ListPlot", "[", 
                RowBox[{
                 RowBox[{"bts", "\[Transpose]"}], ",", "\[IndentingNewLine]", 
                 
                 RowBox[{"PlotMarkers", "\[Rule]", 
                  RowBox[{"{", 
                   RowBox[{
                    RowBox[{"Graphics", "@", 
                    RowBox[{"{", 
                    RowBox[{"Blue", ",", 
                    RowBox[{"Circle", "[", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"0", ",", "0"}], "}"}], ",", "1"}], "]"}]}], 
                    "}"}]}], ",", ".05"}], "}"}]}]}], "]"}]}], "}"}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{"Module", "[", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"showlist", "=", 
                 RowBox[{"{", 
                  RowBox[{"lp", ",", 
                   RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox[
                    RowBox[{"Sin", "[", 
                    RowBox[{"2.", "\[Pi]", " ", "x"}], "]"}],
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0.", ",", "1."}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"Thick", ",", 
                    StyleBox["Green",
                    Background->RGBColor[1, 1, 0]]}], "}"}]}]}], "]"}]}], 
                  "}"}]}], "}"}], ",", "\[IndentingNewLine]", 
               RowBox[{
                RowBox[{"If", "[", 
                 RowBox[{"rlsQ", ",", 
                  RowBox[{"AppendTo", "[", 
                   RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["rlsFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Purple",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                   "]"}]}], "]"}], ";", "\[IndentingNewLine]", 
                RowBox[{"If", "[", 
                 RowBox[{"kalQ", ",", 
                  RowBox[{"AppendTo", "[", 
                   RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["kalFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Cyan",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                   "]"}]}], "]"}], ";", "\[IndentingNewLine]", 
                RowBox[{"Quiet", "@", 
                 RowBox[{"Show", "[", 
                  RowBox[{"showlist", ",", 
                   RowBox[{"Frame", "\[Rule]", "True"}], ",", 
                   RowBox[{"FrameLabel", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"\"\<x\>\"", ",", "\"\<t\>\""}], "}"}]}]}], 
                  "]"}]}]}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}], 
    "]"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Grid", "[", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"Grid", "[", 
         RowBox[{"{", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"Button", "[", 
             RowBox[{"\"\<RESET\>\"", ",", 
              RowBox[{
               RowBox[{"(", 
                RowBox[{
                 RowBox[{"log\[Sigma]\[Zeta]", "=", "0.0"}], ";", 
                 RowBox[{"log\[Sigma]\[Xi]", "=", "1.5"}], ";", 
                 RowBox[{"\[CapitalMu]", "=", "9"}]}], ")"}], "&"}]}], "]"}], 
            ",", "\[IndentingNewLine]", 
            RowBox[{"Control", "[", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"rlsQ", ",", "True", ",", "\"\<RLS\>\""}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}], ",", 
            "\[IndentingNewLine]", 
            RowBox[{"Control", "[", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"kalQ", ",", "True", ",", "\"\<KAL\>\""}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}]}], 
           "}"}], "}"}], "]"}], ",", "\"\<\>\""}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"Control", "[", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
            "\[CapitalMu]", ",", "9", ",", "\"\<polynomial order\>\""}], 
            "}"}], ",", "0", ",", "16", ",", "1", ",", 
           RowBox[{"Appearance", "\[Rule]", 
            RowBox[{"{", "\"\<Labeled\>\"", "}"}]}]}], "}"}], "]"}], ",", 
        "\"\<\>\""}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"Control", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
           "log\[Sigma]\[Xi]", ",", "1.5", ",", 
            "\"\<log \!\(\*SqrtBox[\(P\)]\) (KAL) = (-log \!\(\*SqrtBox[\(\
\[CapitalLambda]\)]\)) (RLS) \>\""}], "}"}], ",", 
          RowBox[{"-", "3"}], ",", "8", ",", 
          RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], 
        "]"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"Control", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
           "log\[Sigma]\[Zeta]", ",", "0.0", ",", 
            "\"\<log \!\(\*SqrtBox[\(\[CapitalZeta]\)]\) (KAL)\>\""}], "}"}], 
          ",", 
          RowBox[{"-", "6"}], ",", "3", ",", 
          RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], 
        "]"}], "}"}]}], "}"}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.727884681931381*^9, 3.7278848244947367`*^9}, 
   3.727884861217602*^9, {3.727884975910451*^9, 3.7278849940673532`*^9}, {
   3.727885103521431*^9, 3.727885154698123*^9}, {3.72788520225443*^9, 
   3.727885279820177*^9}, {3.727885496115718*^9, 3.727885517688189*^9}, {
   3.72788559395383*^9, 3.727885598972475*^9}, {3.7278856296542664`*^9, 
   3.727885630876935*^9}, {3.727885695972756*^9, 3.727885696864628*^9}, {
   3.727886633660364*^9, 3.72788671287046*^9}, {3.727886975364171*^9, 
   3.727886975439041*^9}, {3.727903476653379*^9, 3.7279034819231358`*^9}, {
   3.727903531862627*^9, 3.727903539245574*^9}, 3.727913149489944*^9, {
   3.727915429732944*^9, 3.7279154437948627`*^9}, {3.727915750998211*^9, 
   3.7279158447033873`*^9}, {3.7279213832695303`*^9, 3.72792149154887*^9}, {
   3.727921523149373*^9, 3.72792161270367*^9}, {3.72792165300301*^9, 
   3.727921654632832*^9}, {3.727921753282296*^9, 3.727921753360197*^9}, {
   3.727924008558401*^9, 3.727924045018003*^9}, {3.727924293814445*^9, 
   3.727924370827516*^9}, 3.727965590613636*^9, {3.7279686551525917`*^9, 
   3.727968670349081*^9}, {3.7279689406605043`*^9, 3.727969019631563*^9}, {
   3.727970883056108*^9, 3.727970945128386*^9}, {3.727971005813472*^9, 
   3.727971023734253*^9}, {3.727990640753121*^9, 3.727990674786282*^9}, {
   3.727990711779483*^9, 3.727990808626033*^9}, {3.727991307012423*^9, 
   3.727991307022031*^9}, {3.7279932412769613`*^9, 3.7279932949280367`*^9}, {
   3.7279933910397243`*^9, 3.727993398358789*^9}, {3.727993778490755*^9, 
   3.72799379332897*^9}, {3.727993826040863*^9, 3.7279938751552763`*^9}, {
   3.727993956673335*^9, 3.727993958184173*^9}, 3.727994128012043*^9, {
   3.7280354067714148`*^9, 3.7280354258611927`*^9}, {3.728035634299762*^9, 
   3.728035732029833*^9}, {3.72803585641748*^9, 3.728035906176405*^9}, {
   3.728038924314391*^9, 3.728039041653799*^9}, {3.728039077026232*^9, 
   3.72803913265169*^9}, {3.728039194847865*^9, 3.728039320044661*^9}, {
   3.728044256958378*^9, 3.728044343151896*^9}, {3.728044393583234*^9, 
   3.728044466540698*^9}, 3.7280447095836163`*^9, {3.728044856722988*^9, 
   3.728044959527645*^9}, {3.728044995179022*^9, 3.728044998104682*^9}, {
   3.728045028753289*^9, 3.728045063548128*^9}, {3.728045464570526*^9, 
   3.728045476328084*^9}, {3.728045812340419*^9, 3.728045836978776*^9}, {
   3.7280461335391397`*^9, 3.728046355530389*^9}, {3.728046392282709*^9, 
   3.728046397281275*^9}, {3.728046429888109*^9, 3.728046434285967*^9}, {
   3.728046509047914*^9, 3.728046577986915*^9}, {3.728048625582951*^9, 
   3.728048658147644*^9}, {3.728048704639155*^9, 3.7280487209829884`*^9}, {
   3.728048763333255*^9, 3.728048783520523*^9}, 3.728048849900649*^9, {
   3.728048881350296*^9, 3.7280488887365723`*^9}, {3.7280489358794527`*^9, 
   3.728048947834031*^9}, {3.7280492952517767`*^9, 3.728049427179392*^9}, {
   3.728049506853256*^9, 3.7280496162697783`*^9}, {3.728049702949929*^9, 
   3.728049708359687*^9}, {3.7280497561537037`*^9, 3.728049819625853*^9}, {
   3.728049930158724*^9, 3.728049930640306*^9}, {3.728089854705469*^9, 
   3.728089855621914*^9}, {3.728090725808407*^9, 3.7280907258189697`*^9}, {
   3.728169349695664*^9, 3.728169349720875*^9}, {3.7281694009815397`*^9, 
   3.7281694178910418`*^9}, {3.728169511786654*^9, 3.7281695237214537`*^9}, {
   3.728169612536371*^9, 3.728169630625689*^9}, 3.72825398263583*^9, {
   3.7290928993104963`*^9, 3.7290929198661003`*^9}, {3.729093017541959*^9, 
   3.7290930188886843`*^9}, {3.7290930762770233`*^9, 3.729093076719734*^9}, {
   3.72909336384054*^9, 3.729093404015414*^9}, {3.729095580798506*^9, 
   3.7290957047591*^9}, {3.729095766580648*^9, 3.7290957771880827`*^9}, {
   3.729107615295549*^9, 3.729107649857699*^9}, {3.729107694037426*^9, 
   3.729107743875201*^9}, {3.7291077762521057`*^9, 3.7291078031246223`*^9}, {
   3.729118170017755*^9, 3.729118205624216*^9}, {3.729118574833902*^9, 
   3.729118716465946*^9}, 3.729118800635138*^9, {3.7291198853367987`*^9, 
   3.729119917193569*^9}, {3.729119958982697*^9, 3.729119965955413*^9}, {
   3.7291200866814137`*^9, 3.729120095768982*^9}, {3.729120128434678*^9, 
   3.729120131648838*^9}, {3.729120172278734*^9, 3.729120172356533*^9}, {
   3.729120743402363*^9, 3.7291207441433563`*^9}, {3.729120788602343*^9, 
   3.7291207913479967`*^9}, {3.7291208644443913`*^9, 3.72912086593517*^9}, {
   3.729120949328354*^9, 3.729120951079392*^9}, {3.729120998089177*^9, 
   3.729121101876314*^9}, {3.729161109484889*^9, 3.729161122514371*^9}, {
   3.729161176256221*^9, 3.729161200551162*^9}, {3.729166018684317*^9, 
   3.729166061187087*^9}, {3.729173389847056*^9, 3.729173389871232*^9}, {
   3.729173453409334*^9, 3.729173453420225*^9}, {3.729174596320022*^9, 
   3.7291746086723146`*^9}, {3.72917468944347*^9, 3.729174740763813*^9}, {
   3.729175490419692*^9, 3.729175516174968*^9}, {3.729175639773261*^9, 
   3.729175642039402*^9}, {3.729647100398603*^9, 
   3.729647108685156*^9}},ExpressionUUID->"717ad15f-345b-4b83-90a7-\
88eb7bd2a767"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`kalQ$$ = 
    True, $CellContext`log\[Sigma]\[Zeta]$$ = 
    0., $CellContext`log\[Sigma]\[Xi]$$ = 1.5, $CellContext`rlsQ$$ = 
    True, $CellContext`\[CapitalMu]$$ = 9, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`rlsQ$$], True, "RLS"}, {True, False}}, {{
       Hold[$CellContext`kalQ$$], True, "KAL"}, {True, False}}, {{
       Hold[$CellContext`\[CapitalMu]$$], 9, "polynomial order"}, 0, 16, 1}, {{
       Hold[$CellContext`log\[Sigma]\[Xi]$$], 1.5, 
       "log \!\(\*SqrtBox[\(P\)]\) (KAL) = (-log \!\(\*SqrtBox[\(\
\[CapitalLambda]\)]\)) (RLS) "}, -3, 8}, {{
       Hold[$CellContext`log\[Sigma]\[Zeta]$$], 0., 
       "log \!\(\*SqrtBox[\(\[CapitalZeta]\)]\) (KAL)"}, -6, 3}, {
      Hold[
       Grid[{{
          Grid[{{
             Button[
             "RESET", ($CellContext`log\[Sigma]\[Zeta]$$ = 
               0.; $CellContext`log\[Sigma]\[Xi]$$ = 
               1.5; $CellContext`\[CapitalMu]$$ = 9)& ], 
             Manipulate`Place[1], 
             Manipulate`Place[2]}}], ""}, {
          Manipulate`Place[3], ""}, {
          Manipulate`Place[4]}, {
          Manipulate`Place[5]}}]], Manipulate`Dump`ThisIsNotAControl}}, 
    Typeset`size$$ = {450., {141., 147.}}, Typeset`update$$ = 0, 
    Typeset`initDone$$, Typeset`skipInitDone$$ = 
    True, $CellContext`rlsQ$3086$$ = False, $CellContext`kalQ$3087$$ = 
    False, $CellContext`\[CapitalMu]$3088$$ = 
    0, $CellContext`log\[Sigma]\[Xi]$3089$$ = 
    0, $CellContext`log\[Sigma]\[Zeta]$3090$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     2, StandardForm, 
      "Variables" :> {$CellContext`kalQ$$ = 
        True, $CellContext`log\[Sigma]\[Zeta]$$ = 
        0., $CellContext`log\[Sigma]\[Xi]$$ = 1.5, $CellContext`rlsQ$$ = 
        True, $CellContext`\[CapitalMu]$$ = 9}, "ControllerVariables" :> {
        Hold[$CellContext`rlsQ$$, $CellContext`rlsQ$3086$$, False], 
        Hold[$CellContext`kalQ$$, $CellContext`kalQ$3087$$, False], 
        Hold[$CellContext`\[CapitalMu]$$, $CellContext`\[CapitalMu]$3088$$, 
         0], 
        Hold[$CellContext`log\[Sigma]\[Xi]$$, \
$CellContext`log\[Sigma]\[Xi]$3089$$, 0], 
        Hold[$CellContext`log\[Sigma]\[Zeta]$$, $CellContext`log\[Sigma]\
\[Zeta]$3090$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Module[{$CellContext`x$}, 
        With[{$CellContext`terms$ = \
$CellContext`symbolicPowers[$CellContext`x$, $CellContext`\[CapitalMu]$$], \
$CellContext`cs$ = Map[
            $CellContext`\[Phi][$CellContext`\[CapitalMu]$$], 
            Map[List, 
             Part[$CellContext`bts, 1]]]}, 
         With[{$CellContext`rls$ = Quiet[
             $CellContext`rlsFit[
             10^((-2) $CellContext`log\[Sigma]\[Xi]$$)][$CellContext`\
\[CapitalMu]$$, $CellContext`bts]], $CellContext`kalman$ = \
$CellContext`kalFit[
            10^(2 $CellContext`log\[Sigma]\[Zeta]$$), 
             10^(2 $CellContext`log\[Sigma]\[Xi]$$)][$CellContext`\[CapitalMu]\
$$, $CellContext`bts]}, 
          With[{$CellContext`rlsFn$ = Dot[{$CellContext`terms$}, 
              Part[$CellContext`rls$, 1]], $CellContext`kalFn$ = 
            Dot[{$CellContext`terms$}, 
              Part[$CellContext`kalman$, 1]]}, 
           With[{$CellContext`lp$ = ListPlot[
               Transpose[$CellContext`bts], PlotMarkers -> {
                 Graphics[{Blue, 
                   Circle[{0, 0}, 1]}], 0.05}]}, 
            Module[{$CellContext`showlist$ = {$CellContext`lp$, 
                Plot[
                 Sin[2. Pi $CellContext`x$], {$CellContext`x$, 0., 1.}, 
                 PlotStyle -> {Thick, Green}]}}, If[$CellContext`rlsQ$$, 
               AppendTo[$CellContext`showlist$, 
                
                Plot[$CellContext`rlsFn$, {$CellContext`x$, 0, 1}, 
                 PlotStyle -> {Purple}]]]; If[$CellContext`kalQ$$, 
               AppendTo[$CellContext`showlist$, 
                
                Plot[$CellContext`kalFn$, {$CellContext`x$, 0, 1}, 
                 PlotStyle -> {Cyan}]]]; Quiet[
               
               Show[$CellContext`showlist$, Frame -> True, 
                FrameLabel -> {"x", "t"}]]]]]]]], 
      "Specifications" :> {{{$CellContext`rlsQ$$, True, "RLS"}, {True, False},
          ControlPlacement -> 1}, {{$CellContext`kalQ$$, True, "KAL"}, {
         True, False}, ControlPlacement -> 
         2}, {{$CellContext`\[CapitalMu]$$, 9, "polynomial order"}, 0, 16, 1, 
         Appearance -> {"Labeled"}, ControlPlacement -> 
         3}, {{$CellContext`log\[Sigma]\[Xi]$$, 1.5, 
          "log \!\(\*SqrtBox[\(P\)]\) (KAL) = (-log \!\(\*SqrtBox[\(\
\[CapitalLambda]\)]\)) (RLS) "}, -3, 8, Appearance -> "Labeled", 
         ControlPlacement -> 
         4}, {{$CellContext`log\[Sigma]\[Zeta]$$, 0., 
          "log \!\(\*SqrtBox[\(\[CapitalZeta]\)]\) (KAL)"}, -6, 3, Appearance -> 
         "Labeled", ControlPlacement -> 5}, 
        Grid[{{
           Grid[{{
              Button[
              "RESET", ($CellContext`log\[Sigma]\[Zeta]$$ = 
                0.; $CellContext`log\[Sigma]\[Xi]$$ = 
                1.5; $CellContext`\[CapitalMu]$$ = 9)& ], 
              Manipulate`Place[1], 
              Manipulate`Place[2]}}], ""}, {
           Manipulate`Place[3], ""}, {
           Manipulate`Place[4]}, {
           Manipulate`Place[5]}}]}, "Options" :> {}, "DefaultOptions" :> {}],
     ImageSizeCache->{537., {244., 251.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.7291608432818193`*^9, 3.72916112450849*^9, {3.729161176716465*^9, 
   3.729161201301146*^9}, 3.7291612332234373`*^9, 3.729166027254204*^9, 
   3.729166062247652*^9, 3.729172308588915*^9, 3.729174610695847*^9, {
   3.729174741969412*^9, 3.7291747607471*^9}, 3.729175691543783*^9, 
   3.729175884256433*^9, 3.729183413081258*^9, {3.729183448421172*^9, 
   3.7291834613216057`*^9}, 3.7292559386259813`*^9, 3.729552302382516*^9, 
   3.729557876632798*^9, 3.7296298391238832`*^9, 3.7296346371776114`*^9, 
   3.72964287312507*^9, 3.729642909680106*^9, 3.729643939780446*^9, 
   3.729647111709886*^9, 3.7296471859968224`*^9, 3.729683202732308*^9, 
   3.7296836129467773`*^9, 3.7297781560231*^9, 3.7297792341882687`*^9, 
   3.729779281260777*^9, 3.7298947007340803`*^9, 3.729896006637224*^9, 
   3.729896153410234*^9},ExpressionUUID->"0490c7d1-0cc0-4789-9259-\
c5148960fa40"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Add Observation Noise to RLS", "Subsection",
 CellChangeTimes->{{3.729094358222797*^9, 3.7290944123276787`*^9}, {
  3.729798505179409*^9, 
  3.7297985074907103`*^9}},ExpressionUUID->"8b88ef07-0816-4d11-9d31-\
09ce829acbee"],

Cell[TextData[{
 "RLS, so far, is normalized to unit observation (OBN) noise. How to modify \
RLS to account for non-normalized OBN noise? \n\nScale (each row of) the \
partials by the inverse of the OBN standard deviation, represented below by a \
matrix square root of the OBN covariance ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["P", "\[CapitalZeta]"], TraditionalForm]],ExpressionUUID->
  "47ef5763-33fe-40ce-8d6b-6dca9bd22ffb"],
 ". Finally, rescale the final estimate (not the final covariance) by a \
matrix built from the inverse OBN standard deviation because the recurrent \
normal equations, which incrementally build ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{
       SubsuperscriptBox["P", "\[CapitalZeta]", 
        RowBox[{"-", "1"}]], "\[CenterDot]", 
       RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A", "\[CenterDot]", 
       SubsuperscriptBox["P", "\[CapitalZeta]", 
        RowBox[{"-", "T"}]]}], ")"}], 
     RowBox[{"-", "1"}]], "\[CenterDot]", 
    SubsuperscriptBox["P", "\[CapitalZeta]", 
     RowBox[{"-", "1"}]], "\[CenterDot]", 
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "\[CapitalZeta]"}], 
   TraditionalForm]],ExpressionUUID->"71782ec1-e57e-4a36-9cc9-684e06306435"],
 ", have one too many factors of ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["P", "\[CapitalZeta]"], TraditionalForm]],ExpressionUUID->
  "c536a520-ad98-411c-bb70-5ca584b90b94"],
 "."
}], "Text",
 CellChangeTimes->{{3.729094387864348*^9, 3.729094408224104*^9}, {
  3.7290949467513723`*^9, 3.729094978828157*^9}, {3.7290954227665462`*^9, 
  3.729095484361279*^9}, {3.729107556348858*^9, 3.729107556825692*^9}, {
  3.729169365030899*^9, 3.72916938704521*^9}, {3.7291728712132807`*^9, 
  3.7291729647708797`*^9}, {3.729182737533868*^9, 3.729182738415864*^9}, {
  3.7296381231351852`*^9, 3.729638151867065*^9}, {3.729639553579912*^9, 
  3.72963957002866*^9}, {3.729639602824461*^9, 3.729639607872213*^9}, {
  3.729639746459138*^9, 3.729639966397956*^9}, {3.7296461335142803`*^9, 
  3.729646178394472*^9}, {3.729646644796595*^9, 3.729646660280738*^9}, {
  3.7296839614014273`*^9, 3.72968396184893*^9}, {3.729687467727697*^9, 
  3.7296874741909933`*^9}},ExpressionUUID->"ce468a6b-efd8-447b-925e-\
20cb29496461"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "rlsUpdate", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{
     RowBox[{"rlsUpdate", "[", "sqrtP\[CapitalZeta]_", "]"}], "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"\[Xi]_", ",", "\[CapitalLambda]_"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"\[Zeta]_", ",", "a_"}], "}"}]}], "]"}], ":=", 
    "\[IndentingNewLine]", 
    RowBox[{"With", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"sP\[CapitalZeta]ia", "=", 
        RowBox[{"LinearSolve", "[", 
         RowBox[{"sqrtP\[CapitalZeta]", ",", "a"}], "]"}]}], "}"}], ",", 
      "\[IndentingNewLine]", 
      RowBox[{"With", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"\[CapitalPi]", "=", 
          RowBox[{"(", 
           RowBox[{"\[CapitalLambda]", "+", 
            RowBox[{
             RowBox[{"sP\[CapitalZeta]ia", "\[Transpose]"}], ".", 
             "sP\[CapitalZeta]ia"}]}], ")"}]}], "}"}], ",", 
        "\[IndentingNewLine]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"LinearSolve", "[", 
           RowBox[{"\[CapitalPi]", ",", 
            RowBox[{"(", 
             RowBox[{
              RowBox[{
               RowBox[{"sP\[CapitalZeta]ia", "\[Transpose]"}], ".", 
               "\[Zeta]"}], "+", 
              RowBox[{"\[CapitalLambda]", ".", "\[Xi]"}]}], ")"}]}], "]"}], 
          ",", "\[CapitalPi]"}], "}"}]}], "]"}]}], "]"}]}], ";"}], 
  "\[IndentingNewLine]"}], "\[IndentingNewLine]", 
 RowBox[{"Manipulate", "[", "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"\[Xi]0", "=", 
        RowBox[{"(", GridBox[{
           {"0"},
           {"0"}
          }], ")"}]}], ",", 
       RowBox[{"\[CapitalLambda]0", "=", 
        RowBox[{"(", GridBox[{
           {"1.0*^-6", "0"},
           {"0", "1.0*^-6"}
          }], ")"}]}], ",", "\[IndentingNewLine]", 
       RowBox[{"inputs", "=", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"List", "/@", 
            RowBox[{"data", "\[LeftDoubleBracket]", 
             RowBox[{"1", ";;", "n"}], "\[RightDoubleBracket]"}]}], ",", 
           RowBox[{"List", "/@", 
            RowBox[{"partials", "\[LeftDoubleBracket]", 
             RowBox[{"1", ";;", "n"}], "\[RightDoubleBracket]"}]}]}], "}"}], 
         "\[Transpose]"}]}]}], "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{"Module", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
        "\[Xi]rr", ",", "\[Xi]r", ",", "\[Xi]k", ",", "\[CapitalPi]rr", ",", 
         "\[CapitalPi]r", ",", "\[CapitalPi]k"}], "}"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{
        RowBox[{"(", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"\[Xi]rr", ",", "\[CapitalPi]rr"}], "}"}], "=", 
          RowBox[{"Fold", "[", 
           RowBox[{
            RowBox[{"rlsUpdate", "[", 
             RowBox[{"\[Sigma]", " ", 
              RowBox[{"IdentityMatrix", "[", "1", "]"}]}], "]"}], ",", 
            "\[IndentingNewLine]", 
            RowBox[{"{", 
             RowBox[{"\[Xi]0", ",", "\[CapitalLambda]0"}], "}"}], ",", 
            "inputs"}], "]"}]}], ")"}], ";", "\[IndentingNewLine]", 
        RowBox[{"(", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"\[Xi]r", ",", "\[CapitalPi]r"}], "}"}], "=", 
          RowBox[{"Fold", "[", 
           RowBox[{"update", ",", 
            RowBox[{"{", 
             RowBox[{"\[Xi]0", ",", "\[CapitalLambda]0"}], "}"}], ",", 
            "inputs"}], "]"}]}], ")"}], ";", "\[IndentingNewLine]", 
        RowBox[{"(", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"\[Xi]k", ",", "\[CapitalPi]k"}], "}"}], "=", 
          RowBox[{"Fold", "[", 
           RowBox[{
            RowBox[{"kalmanUpdate", "[", 
             SuperscriptBox["\[Sigma]", "2"], "]"}], ",", 
            RowBox[{"{", 
             RowBox[{"\[Xi]0", ",", 
              RowBox[{"Inverse", "@", "\[CapitalLambda]0"}]}], "}"}], ",", 
            "inputs"}], "]"}]}], ")"}], ";", "\[IndentingNewLine]", 
        RowBox[{"MatrixForm", "@", 
         RowBox[{"{", "\[IndentingNewLine]", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{
              FractionBox[
               RowBox[{"IdentityMatrix", "[", "2", "]"}], "\[Sigma]"], ".", 
              "\[Xi]rr"}], ",", "\[Xi]r", ",", "\[Xi]k"}], "}"}], ",", 
           RowBox[{"{", 
            RowBox[{"\[CapitalPi]rr", ",", 
             RowBox[{"\[CapitalPi]r", "/", 
              SuperscriptBox["\[Sigma]", "2"]}], ",", 
             RowBox[{"Inverse", "@", "\[CapitalPi]k"}]}], "}"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"Chop", "[", 
              RowBox[{
               RowBox[{"Abs", "[", 
                RowBox[{"\[CapitalPi]rr", "-", 
                 RowBox[{"\[CapitalPi]r", "/", 
                  SuperscriptBox["\[Sigma]", "2"]}]}], "]"}], ",", 
               SuperscriptBox["10", 
                RowBox[{"-", "6"}]]}], "]"}], ",", "\[IndentingNewLine]", 
             RowBox[{"Chop", "[", 
              RowBox[{
               RowBox[{"Abs", "[", 
                RowBox[{
                 RowBox[{"Inverse", "@", "\[CapitalPi]k"}], "-", 
                 RowBox[{"\[CapitalPi]r", "/", 
                  SuperscriptBox["\[Sigma]", "2"]}]}], "]"}], ",", 
               SuperscriptBox["10", 
                RowBox[{"-", "6"}]]}], "]"}], ",", "\[IndentingNewLine]", 
             RowBox[{"Chop", "[", 
              RowBox[{
               RowBox[{"Abs", "[", 
                RowBox[{
                 RowBox[{"Inverse", "@", "\[CapitalPi]k"}], "-", 
                 "\[CapitalPi]rr"}], "]"}], ",", 
               SuperscriptBox["10", 
                RowBox[{"-", "6"}]]}], "]"}]}], "}"}]}], "}"}]}]}]}], "]"}]}],
     "]"}], ",", "\[IndentingNewLine]", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"n", ",", "3"}], "}"}], ",", "3", ",", "nData", ",", "1", ",", 
     RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], ",", 
   "\[IndentingNewLine]", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"\[Sigma]", ",", "1"}], "}"}], ",", 
     RowBox[{"-", "100"}], ",", "100", ",", 
     RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}]}], 
  "]"}]}], "Input",
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
   3.7274725926081057`*^9}, {3.727473460371025*^9, 3.727473470385874*^9}, {
   3.727967024755598*^9, 3.7279670373987417`*^9}, 3.727967235445434*^9, {
   3.728948393392125*^9, 3.728948394937408*^9}, {3.7290949247050467`*^9, 
   3.729094943930032*^9}, {3.729095003042301*^9, 3.729095003876113*^9}, {
   3.7290950412490463`*^9, 3.729095051008603*^9}, {3.7290950822550173`*^9, 
   3.729095135857238*^9}, {3.7290951897446327`*^9, 3.729095402554632*^9}, {
   3.729107574665441*^9, 3.7291075901656437`*^9}, 3.7291080484571247`*^9, {
   3.729108084736548*^9, 3.72910825558943*^9}, {3.729161604459531*^9, 
   3.729161610440398*^9}, {3.7291616424288397`*^9, 3.729161760746108*^9}, {
   3.729161803140615*^9, 3.72916181703271*^9}, {3.7291721056426287`*^9, 
   3.729172155283436*^9}, {3.7291721980443363`*^9, 3.729172276420932*^9}, {
   3.729172336052294*^9, 3.729172342704544*^9}, {3.7291723737632227`*^9, 
   3.729172427102948*^9}, {3.729172497300097*^9, 3.7291726002607937`*^9}, {
   3.729172635205014*^9, 3.7291727804950743`*^9}, {3.729172814049247*^9, 
   3.72917282262862*^9}, {3.729172924194323*^9, 3.729172927538876*^9}, {
   3.7291729818445587`*^9, 3.729173000378613*^9}, {3.729174803584015*^9, 
   3.729174827188703*^9}, {3.729635300462594*^9, 3.729635329025786*^9}, 
   3.729636008968544*^9, {3.729636272681835*^9, 3.7296363081017237`*^9}, {
   3.729636416390744*^9, 3.7296364270043907`*^9}, {3.7296365151239147`*^9, 
   3.729636544411797*^9}, {3.729636598430265*^9, 3.729636615497266*^9}, {
   3.729636673165737*^9, 3.729636822399268*^9}, {3.72963687410984*^9, 
   3.7296368920773907`*^9}, {3.7296369845843077`*^9, 
   3.7296370095969133`*^9}, {3.7296371791119556`*^9, 3.729637188403821*^9}, {
   3.729637251543976*^9, 3.7296374636954813`*^9}, {3.7296375127019663`*^9, 
   3.729637650441799*^9}, 3.729637697282694*^9, 3.729637746956402*^9, {
   3.729637912605995*^9, 3.729638007565567*^9}, {3.7296380790331573`*^9, 
   3.729638109879693*^9}, {3.729638194298698*^9, 3.7296382277516327`*^9}, 
   3.72964577609685*^9, {3.7296460525874643`*^9, 3.729646120714403*^9}, 
   3.729682464425685*^9, {3.729682496154779*^9, 3.729682501153379*^9}, {
   3.729683983125988*^9, 3.729683996176063*^9}, {3.7296853629102182`*^9, 
   3.7296853792222557`*^9}, {3.729685411789864*^9, 3.729685447926292*^9}, {
   3.72968551455221*^9, 3.729685521383741*^9}, {3.729685560401882*^9, 
   3.729685629173448*^9}, {3.7296856732126093`*^9, 3.729685903363908*^9}, {
   3.729686096422873*^9, 3.729686185724934*^9}, {3.7296862221744957`*^9, 
   3.729686222655352*^9}, {3.729686261470471*^9, 3.729686307392109*^9}, {
   3.729686344163858*^9, 3.729686424060445*^9}, {3.729686474516107*^9, 
   3.7296865793443832`*^9}, {3.729686619156342*^9, 3.72968666650456*^9}, {
   3.729687217278598*^9, 3.7296872845587063`*^9}, {3.7296876028411913`*^9, 
   3.7296876338678923`*^9}, {3.729798616749312*^9, 
   3.729798662617351*^9}},ExpressionUUID->"985a63ca-302c-4f24-8d5d-\
5a231996a4f5"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`n$$ = 3, $CellContext`\[Sigma]$$ = 1, 
    Typeset`show$$ = True, Typeset`bookmarkList$$ = {}, 
    Typeset`bookmarkMode$$ = "Menu", Typeset`animator$$, Typeset`animvar$$ = 
    1, Typeset`name$$ = "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`n$$], 3}, 3, 119, 1}, {{
       Hold[$CellContext`\[Sigma]$$], 1}, -100, 100}}, Typeset`size$$ = {
    683., {63.41754150390625, 70.58245849609375}}, Typeset`update$$ = 0, 
    Typeset`initDone$$, Typeset`skipInitDone$$ = True, $CellContext`n$3312$$ =
     0, $CellContext`\[Sigma]$3313$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`n$$ = 3, $CellContext`\[Sigma]$$ = 1}, 
      "ControllerVariables" :> {
        Hold[$CellContext`n$$, $CellContext`n$3312$$, 0], 
        Hold[$CellContext`\[Sigma]$$, $CellContext`\[Sigma]$3313$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> 
      With[{$CellContext`\[Xi]0$ = {{0}, {
          0}}, $CellContext`\[CapitalLambda]0$ = {{1.*^-6, 0}, {
           0, 1.*^-6}}, $CellContext`inputs$ = Transpose[{
            Map[List, 
             Part[$CellContext`data, 
              Span[1, $CellContext`n$$]]], 
            Map[List, 
             Part[$CellContext`partials, 
              Span[1, $CellContext`n$$]]]}]}, 
        Module[{$CellContext`\[Xi]rr$, $CellContext`\[Xi]r$, $CellContext`\
\[Xi]k$, $CellContext`\[CapitalPi]rr$, $CellContext`\[CapitalPi]r$, \
$CellContext`\[CapitalPi]k$}, {$CellContext`\[Xi]rr$, $CellContext`\
\[CapitalPi]rr$} = Fold[
            $CellContext`rlsUpdate[$CellContext`\[Sigma]$$ 
             IdentityMatrix[
              1]], {$CellContext`\[Xi]0$, $CellContext`\[CapitalLambda]0$}, \
$CellContext`inputs$]; {$CellContext`\[Xi]r$, $CellContext`\[CapitalPi]r$} = 
          Fold[$CellContext`update, {$CellContext`\[Xi]0$, $CellContext`\
\[CapitalLambda]0$}, $CellContext`inputs$]; {$CellContext`\[Xi]k$, \
$CellContext`\[CapitalPi]k$} = Fold[
            $CellContext`kalmanUpdate[$CellContext`\[Sigma]$$^2], \
{$CellContext`\[Xi]0$, 
             Inverse[$CellContext`\[CapitalLambda]0$]}, $CellContext`inputs$]; 
         MatrixForm[{{
             Dot[
             IdentityMatrix[
               2]/$CellContext`\[Sigma]$$, $CellContext`\[Xi]rr$], \
$CellContext`\[Xi]r$, $CellContext`\[Xi]k$}, {$CellContext`\[CapitalPi]rr$, \
$CellContext`\[CapitalPi]r$/$CellContext`\[Sigma]$$^2, 
             Inverse[$CellContext`\[CapitalPi]k$]}, {
             Chop[
              
              Abs[$CellContext`\[CapitalPi]rr$ - \
$CellContext`\[CapitalPi]r$/$CellContext`\[Sigma]$$^2], 10^(-6)], 
             Chop[
              Abs[
              Inverse[$CellContext`\[CapitalPi]k$] - \
$CellContext`\[CapitalPi]r$/$CellContext`\[Sigma]$$^2], 10^(-6)], 
             Chop[
              Abs[
              Inverse[$CellContext`\[CapitalPi]k$] - \
$CellContext`\[CapitalPi]rr$], 10^(-6)]}}]]], 
      "Specifications" :> {{{$CellContext`n$$, 3}, 3, 119, 1, Appearance -> 
         "Labeled"}, {{$CellContext`\[Sigma]$$, 1}, -100, 100, Appearance -> 
         "Labeled"}}, "Options" :> {}, "DefaultOptions" :> {}],
     ImageSizeCache->{738., {132., 139.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.72968605374187*^9, {3.729686160079255*^9, 3.729686224438879*^9}, 
   3.729686308803747*^9, 3.7296863933549547`*^9, 3.729686424622281*^9, {
   3.729686501023221*^9, 3.72968651336834*^9}, {3.7296865684021482`*^9, 
   3.729686582348391*^9}, {3.729686643824795*^9, 3.7296866678473473`*^9}, 
   3.729687255698826*^9, 3.729687285772131*^9, {3.7296876265461206`*^9, 
   3.7296876456103354`*^9}, 3.729778156089766*^9, 3.729779234251914*^9, 
   3.729779281327022*^9, {3.729798617730486*^9, 3.7297986636105833`*^9}, 
   3.7298947009139147`*^9, 3.729896006704764*^9, 
   3.729896153679371*^9},ExpressionUUID->"be2c524d-5677-4bbf-bb9a-\
ab58d5ab9d86"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["RLS beats KAL", "Subsection",
 CellChangeTimes->{{3.729182753746653*^9, 3.729182764662409*^9}, {
  3.7291917374240217`*^9, 3.729191746263137*^9}, {3.7296405387074757`*^9, 
  3.72964054391427*^9}},ExpressionUUID->"be355efe-81b9-4077-add8-\
cf60273c9546"],

Cell["\<\
KAL and renormalized RLS are mathematically equivalent. Operationally, KAL \
uses subtraction to recur the covariance of the estimates, so is exposed to \
catastrophic cancelation. RLS only adds to the information matrix, so is \
exposed only to ill-conditioning, which is empirically less severe. We show \
this below.\
\>", "Text",
 CellChangeTimes->{{3.729108318055666*^9, 3.729108347023395*^9}, {
  3.729119343997692*^9, 3.729119359971643*^9}, {3.729169476126769*^9, 
  3.729169477106061*^9}, {3.72917483481177*^9, 3.7291748799421263`*^9}, {
  3.729191759307276*^9, 3.729191781475971*^9}, {3.729640562998232*^9, 
  3.729640568230112*^9}, {3.729640980175406*^9, 3.729640998789782*^9}, {
  3.7296411048780746`*^9, 3.7296411151875257`*^9}, {3.729641300872263*^9, 
  3.729641334229947*^9}, {3.7296461936050053`*^9, 3.729646207586768*^9}, {
  3.729712752322254*^9, 3.729712803608899*^9}, {3.7297987012257757`*^9, 
  3.729798723965109*^9}},ExpressionUUID->"fa965554-b77d-42f6-898d-\
053620725a95"]
}, Open  ]]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Regularization and MAP", "Chapter",
 CellChangeTimes->{{3.727878613935317*^9, 3.727878617609169*^9}},
 CellTags->"c:14",ExpressionUUID->"3a857b02-02f4-4444-9302-60878b838b66"],

Cell[TextData[{
 "Bishop reports ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Beta]", "=", 
    RowBox[{"11.111", "\[Ellipsis]"}]}], TraditionalForm]],ExpressionUUID->
  "8e22fb9c-13dd-4596-83d2-17c772c852a1"],
 " and ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Alpha]", "=", "0.005"}], TraditionalForm]],ExpressionUUID->
  "9439b565-4e31-4d22-ae02-3f68785439e4"],
 " in his figure 1.17 (page 32) and in equations 1.70 through 1.72 (page 31), \
which look suspiciously like the equations for Kalman filtering. Bishop\
\[CloseCurlyQuote]s matrix ",
 Cell[BoxData[
  FormBox[
   StyleBox["S",
    FontWeight->"Bold"], TraditionalForm]],ExpressionUUID->
  "15229e6b-eefa-48a8-80b0-df50abb6726b"],
 StyleBox[" looks like ",
  FontWeight->"Plain"],
 Cell[BoxData[
  FormBox[
   SuperscriptBox[
    StyleBox["D",
     FontWeight->"Bold"], 
    RowBox[{"\[ThinSpace]", 
     RowBox[{"-", "1"}]}]], TraditionalForm]],ExpressionUUID->
  "1c5226ee-b619-4054-a482-ddd3e76e3691"],
 " in ",
 Cell[BoxData[
  FormBox["kalmanUpdate", TraditionalForm]], "Code",ExpressionUUID->
  "de857dd2-14f7-46ca-88a7-ba75c4137d1c"],
 " above. Let\[CloseCurlyQuote]s reproduce MAP via RLS and KAL."
}], "Text",
 CellChangeTimes->{{3.727971621209344*^9, 3.727971949635846*^9}, {
  3.72797205224653*^9, 3.7279722021279373`*^9}, {3.7279725817509613`*^9, 
  3.727972703314744*^9}, {3.7280847454753532`*^9, 3.728084792840749*^9}, {
  3.728220011630794*^9, 3.7282200748560743`*^9}, {3.728252317415781*^9, 
  3.728252334400373*^9}, {3.729171081665955*^9, 3.729171117218204*^9}, {
  3.729191351993813*^9, 3.729191365808433*^9}, {3.7291948298181257`*^9, 
  3.729194830792169*^9}, {3.729798750699163*^9, 
  3.72979875284214*^9}},ExpressionUUID->"62f80a97-9d18-4705-8ec3-\
21b92ba1ba14"],

Cell[CellGroupData[{

Cell["Bishop\[CloseCurlyQuote]s MAP", "Subchapter",
 CellChangeTimes->{{3.72797221730235*^9, 3.727972224770916*^9}, {
  3.728034928939948*^9, 3.7280349304923964`*^9}},
 CellTags->"c:15",ExpressionUUID->"6092c50b-6db9-47d8-930c-78c31ddc0d05"],

Cell[TextData[{
 "Bishop\[CloseCurlyQuote]s equations 1.70 through 1.72 are reproduced here. \
The dimensions of the identity matrix in ",
 Cell[BoxData[
  FormBox["S", TraditionalForm]],ExpressionUUID->
  "1eacf56a-a8d9-4664-995f-125386c0e309"],
 " is ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalMu]", "+", "1"}], TraditionalForm]],ExpressionUUID->
  "3ce7d474-d9b6-4b6b-9a80-613654c0eeeb"],
 ", where ",
 Cell[BoxData[
  FormBox["\[CapitalMu]", TraditionalForm]],ExpressionUUID->
  "5120e51b-c864-42ac-a6ed-b95ded545421"],
 " is the order of the polynomial, one more than ",
 Cell[BoxData[
  FormBox["\[CapitalMu]", TraditionalForm]],ExpressionUUID->
  "aab244ae-ede9-45f4-b7b4-4d49f0916e6c"],
 " to account for the leading bias term:"
}], "Text",
 CellChangeTimes->{{3.727972249677867*^9, 3.727972263698797*^9}, {
   3.727992395654808*^9, 3.7279924502184677`*^9}, {3.7281700269116917`*^9, 
   3.7281700419010553`*^9}, {3.728170120216963*^9, 3.728170134209874*^9}, {
   3.72911884925035*^9, 3.729118878325338*^9}, {3.729162024195531*^9, 
   3.7291620299164963`*^9}, {3.7291711306418667`*^9, 3.729171176680653*^9}, 
   3.729178684600383*^9, {3.729182872291184*^9, 3.7291828738856*^9}, {
   3.729798765133129*^9, 
   3.729798765324222*^9}},ExpressionUUID->"0eb3be5c-6ad1-4698-89d4-\
abf74f39cd4d"],

Cell[BoxData[
 FormBox[
  RowBox[{
   RowBox[{"m", "(", "x", ")"}], "  ", "=", "  ", 
   RowBox[{"\[Beta]", " ", 
    RowBox[{
     RowBox[{
      RowBox[{"\[Phi]", "\[ThinSpace]", "(", "x", ")"}], "\[Transpose]"}], 
     "\[CenterDot]", "S", "\[CenterDot]", 
     RowBox[{
      UnderoverscriptBox["\[Sum]", 
       RowBox[{"n", "=", "1"}], "N"], 
      RowBox[{
       RowBox[{"\[Phi]", "\[ThinSpace]", "(", 
        SubscriptBox["x", "n"], ")"}], 
       SubscriptBox["t", "n"]}]}]}]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.727972280222818*^9, 3.7279724431858997`*^9}, {
  3.727972476930735*^9, 3.727972478697866*^9}, {3.7279730887912483`*^9, 
  3.7279731267447147`*^9}},ExpressionUUID->"4049a1f2-9c54-41f2-b358-\
29df90610bc1"],

Cell[BoxData[
 FormBox[
  RowBox[{
   RowBox[{
    SuperscriptBox["s", "2"], "(", "x", ")"}], "  ", "=", "  ", 
   RowBox[{
    SuperscriptBox["\[Beta]", 
     RowBox[{"\[ThinSpace]", 
      RowBox[{"-", "1"}]}]], "+", 
    RowBox[{
     RowBox[{
      RowBox[{"\[Phi]", "\[ThinSpace]", "(", "x", ")"}], "\[Transpose]"}], 
     "\[CenterDot]", "S", "\[CenterDot]", 
     RowBox[{"\[Phi]", "\[ThinSpace]", "(", "x", ")"}]}]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.7279724613260727`*^9, 3.727972528960863*^9}, {
  3.727972730192233*^9, 3.727972730194661*^9}, {3.727973130733033*^9, 
  3.727973133972931*^9}},ExpressionUUID->"1e604de0-c480-422c-98f9-\
a52ec6dcd1bf"],

Cell[BoxData[
 FormBox[
  RowBox[{
   SuperscriptBox["S", 
    RowBox[{"\[ThinSpace]", 
     RowBox[{"-", "1"}]}]], "  ", 
   OverscriptBox["=", "def"], "  ", 
   RowBox[{
    RowBox[{"\[Alpha]", " ", 
     SubscriptBox["I", 
      RowBox[{"\[CapitalMu]", "+", "1"}]]}], "+", 
    RowBox[{"\[Beta]", 
     RowBox[{
      UnderoverscriptBox["\[Sum]", 
       RowBox[{"n", "=", "1"}], "N"], 
      RowBox[{
       RowBox[{"\[Phi]", "\[ThinSpace]", "(", 
        SubscriptBox["x", "n"], ")"}], "\[CenterDot]", 
       RowBox[{
        RowBox[{"\[Phi]", "\[ThinSpace]", "(", 
         SubscriptBox["x", "n"], ")"}], "\[Transpose]"}]}]}]}]}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.72797275156035*^9, 3.727972881609983*^9}, {
  3.727973139344582*^9, 3.727973142448781*^9}, {3.727992385246423*^9, 
  3.727992388437778*^9}},ExpressionUUID->"c1232a65-83af-4c7f-9ee3-\
c6e3459170d5"],

Cell["\<\
Here are links between Bishop\[CloseCurlyQuote]s formulation and ours, \
without derivation. \
\>", "Text",
 CellChangeTimes->{{3.728247291344137*^9, 3.728247310423942*^9}, {
  3.728248735711397*^9, 
  3.7282487376877623`*^9}},ExpressionUUID->"641604c9-a9b1-4fe3-99e8-\
e2170a8aec43"],

Cell[BoxData[
 FormBox[
  RowBox[{
   RowBox[{
    UnderoverscriptBox["\[Sum]", 
     RowBox[{"n", "=", "1"}], "N"], 
    RowBox[{
     RowBox[{"\[Phi]", "\[ThinSpace]", "(", 
      SubscriptBox["x", "n"], ")"}], 
     SubscriptBox["t", "n"]}]}], "=", 
   RowBox[{
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "\[CapitalZeta]"}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.728246767415718*^9, 3.728246838582246*^9}, {
  3.728246899084139*^9, 3.72824690103373*^9}, {3.728247197825539*^9, 
  3.728247228753024*^9}, {3.728247278577318*^9, 
  3.72824728616096*^9}},ExpressionUUID->"8c251b39-002c-42ca-953a-\
b8b5377cb443"],

Cell[BoxData[
 FormBox[
  RowBox[{
   RowBox[{
    UnderscriptBox["lim", 
     RowBox[{"\[Alpha]", "\[Rule]", "0"}]], 
    RowBox[{"(", "\[ThinSpace]", 
     RowBox[{
      SuperscriptBox["\[Beta]", 
       RowBox[{"\[ThinSpace]", 
        RowBox[{"-", "1"}]}]], 
      SuperscriptBox["S", 
       RowBox[{"\[ThinSpace]", 
        RowBox[{"-", "1"}]}]]}], ")"}]}], "=", 
   RowBox[{
    RowBox[{"A", "\[Transpose]"}], "\[CenterDot]", "A"}]}], 
  TraditionalForm]], "DisplayFormulaNumbered",
 CellChangeTimes->{{3.728247724107789*^9, 
  3.728247835449356*^9}},ExpressionUUID->"9155b152-4123-446a-be5f-\
d826a88375df"],

Cell[CellGroupData[{

Cell["\[CapitalPhi] Vectors", "Subsection",
 CellChangeTimes->{{3.728246200325514*^9, 
  3.72824620633247*^9}},ExpressionUUID->"dac7c078-3691-4ca0-b55d-\
7f5b5f8e8bde"],

Cell[TextData[{
 "Bishop\[CloseCurlyQuote]s ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Phi]", "\[ThinSpace]", "(", 
    SubscriptBox["x", "n"], ")"}], TraditionalForm]],ExpressionUUID->
  "d0357893-7a34-47d5-b9df-6d65e4cd6db3"],
 " is a ",
 Cell[BoxData[
  FormBox[
   RowBox[{"(", 
    RowBox[{"\[CapitalMu]", "+", "1"}], ")"}], TraditionalForm]],
  ExpressionUUID->"be18f1f6-fa19-4618-85e4-a7b0798c19b0"],
 "-dimensional column vector of the powers of the ",
 Cell[BoxData[
  FormBox[
   SuperscriptBox["n", "th"], TraditionalForm]],ExpressionUUID->
  "a695a214-da64-4bf6-9e54-8c1109d67926"],
 " input ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["x", "n"], TraditionalForm]],ExpressionUUID->
  "a592915b-b190-4cca-a80f-fa0eb5f0f7b6"],
 ". These powers are the basis functions of a polynomial model for the curve. \
",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Phi]", "\[ThinSpace]", "(", 
    SubscriptBox["x", "n"], ")"}], TraditionalForm]],ExpressionUUID->
  "c73c1dda-88c8-44a2-92c1-fc534674e49f"],
 " is the dual (transpose) of one row of our partials matrix ",
 Cell[BoxData[
  FormBox["A", TraditionalForm]],ExpressionUUID->
  "711ac6f0-8e88-49d6-896e-5df4757ff9bf"],
 ". \n\nAs written, Bishop\[CloseCurlyQuote]s equations are non-recurrent, \
requiring all data ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["t", "n"], TraditionalForm]],ExpressionUUID->
  "8c93d51c-82cf-4849-9217-6ca946a75539"],
 " and ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Phi]", "\[ThinSpace]", "(", 
    SubscriptBox["x", "n"], ")"}], TraditionalForm]],ExpressionUUID->
  "a73423ff-d81a-49db-8ce5-8bf4b609f34c"],
 " in memory. Plus, as written, they require inverting matrix ",
 Cell[BoxData[
  FormBox["S", TraditionalForm]],ExpressionUUID->
  "883351be-2cb8-44c7-a551-6e0d6beceae2"],
 ". They thus suffer from the operational ills of the normal equations. "
}], "Text",
 CellChangeTimes->{{3.727972933675117*^9, 3.727973078876171*^9}, {
   3.7279731471152554`*^9, 3.727973158916931*^9}, {3.727973221836879*^9, 
   3.727973225832409*^9}, {3.727973303634624*^9, 3.727973419552944*^9}, {
   3.72797356270901*^9, 3.727973628849347*^9}, {3.72797366287252*^9, 
   3.727973666796633*^9}, {3.727974021159554*^9, 3.727974048392016*^9}, {
   3.7279742261495733`*^9, 3.727974272673163*^9}, {3.7279743703033*^9, 
   3.727974393755924*^9}, {3.7279744457003307`*^9, 3.7279744754841213`*^9}, {
   3.7279909913943167`*^9, 3.7279910540283127`*^9}, {3.727992083686421*^9, 
   3.7279920838762627`*^9}, {3.7279924628991203`*^9, 3.727992516567472*^9}, {
   3.728034977126224*^9, 3.7280350056809273`*^9}, {3.7280848433291597`*^9, 
   3.728084865045436*^9}, {3.728084911051063*^9, 3.7280851520750723`*^9}, {
   3.7281700673790197`*^9, 3.728170114044112*^9}, {3.72817017243155*^9, 
   3.728170228710331*^9}, {3.728220150909762*^9, 3.728220256483842*^9}, {
   3.72822645762605*^9, 3.728226489609394*^9}, {3.728252404072995*^9, 
   3.728252407743845*^9}, {3.729031135725021*^9, 3.7290311504327307`*^9}, {
   3.729031182197022*^9, 3.729031247473465*^9}, {3.729118895789219*^9, 
   3.7291189027722054`*^9}, {3.7291191791553907`*^9, 3.729119179167945*^9}, {
   3.7291712705279293`*^9, 3.729171273095373*^9}, {3.7291716361016483`*^9, 
   3.729171713599073*^9}, {3.7291749543161783`*^9, 3.729174983647272*^9}, 
   3.7291828972165833`*^9, {3.729798784388638*^9, 
   3.7297987849222937`*^9}},ExpressionUUID->"e8a66e23-4f91-4ac0-ba53-\
1b2492f56003"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "\[Phi]", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{"\[Phi]", "[", "\[CapitalMu]_", "]"}], "[", "xn_", "]"}], ":=", 
   RowBox[{
    RowBox[{"Quiet", "@", 
     RowBox[{"Table", "[", 
      RowBox[{
       SuperscriptBox["xn", "i"], ",", 
       RowBox[{"{", 
        RowBox[{"i", ",", "0", ",", "\[CapitalMu]"}], "}"}]}], "]"}]}], "/.", 
    
    RowBox[{"{", 
     RowBox[{"Indeterminate", "\[Rule]", "1"}], "}"}]}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"MatrixForm", "/@", 
  RowBox[{
   RowBox[{"\[Phi]", "[", "3", "]"}], "/@", 
   RowBox[{"List", "/@", 
    RowBox[{
    "bts", "\[LeftDoubleBracket]", "1", 
     "\[RightDoubleBracket]"}]}]}]}]}], "Input",
 CellChangeTimes->{{3.727973167925046*^9, 3.7279732069191923`*^9}, {
   3.727973258420764*^9, 3.727973267473878*^9}, {3.727973429851573*^9, 
   3.727973456984548*^9}, {3.7279735073990107`*^9, 3.727973544918976*^9}, {
   3.727973599459084*^9, 3.727973603790498*^9}, {3.7279736372428493`*^9, 
   3.727973649545477*^9}, {3.72797372689071*^9, 3.7279737331067553`*^9}, {
   3.727973816644998*^9, 3.7279738168679523`*^9}, {3.72797400882194*^9, 
   3.7279740141305532`*^9}, {3.727974059584772*^9, 3.727974079989175*^9}, {
   3.727974139169652*^9, 3.727974144037814*^9}, {3.727974283500222*^9, 
   3.727974357586182*^9}, {3.7279743965807533`*^9, 3.727974431722498*^9}, {
   3.727974493179165*^9, 3.7279747668644867`*^9}, {3.727989252021517*^9, 
   3.727989259286603*^9}, {3.7279894297361*^9, 3.727989457309639*^9}, {
   3.72799130695959*^9, 3.727991323954713*^9}, {3.7279914092481813`*^9, 
   3.727991418823888*^9}, {3.727992110982379*^9, 3.727992136250567*^9}, 
   3.727992510695593*^9, 3.727993474811754*^9, 
   3.729175642856516*^9},ExpressionUUID->"1b66ed75-d4a2-4cfb-9759-\
96f00155ca58"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   TagBox[
    RowBox[{"(", "\[NoBreak]", GridBox[{
       {"1"},
       {"0.`"},
       {"0.`"},
       {"0.`"}
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
       {"1.`"},
       {"0.1111111111111111`"},
       {"0.012345679012345678`"},
       {"0.0013717421124828531`"}
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
       {"1.`"},
       {"0.2222222222222222`"},
       {"0.04938271604938271`"},
       {"0.010973936899862825`"}
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
       {"1.`"},
       {"0.3333333333333333`"},
       {"0.1111111111111111`"},
       {"0.037037037037037035`"}
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
       {"1.`"},
       {"0.4444444444444444`"},
       {"0.19753086419753085`"},
       {"0.0877914951989026`"}
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
       {"1.`"},
       {"0.5555555555555556`"},
       {"0.308641975308642`"},
       {"0.1714677640603567`"}
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
       {"1.`"},
       {"0.6666666666666666`"},
       {"0.4444444444444444`"},
       {"0.2962962962962963`"}
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
       {"1.`"},
       {"0.7777777777777777`"},
       {"0.6049382716049381`"},
       {"0.4705075445816184`"}
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
       {"1.`"},
       {"0.8888888888888888`"},
       {"0.7901234567901234`"},
       {"0.7023319615912208`"}
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
       {"1.`"},
       {"1.`"},
       {"1.`"},
       {"1.`"}
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
  3.72797476735454*^9, {3.727989442724881*^9, 3.7279894588380623`*^9}, {
   3.727991319054626*^9, 3.727991333268414*^9}, {3.727992119104147*^9, 
   3.727992136593679*^9}, 3.727992528933445*^9, 3.727993509509782*^9, 
   3.728044352739295*^9, 3.7280464487735233`*^9, 3.728066471393063*^9, 
   3.728068121686639*^9, 3.728083785006975*^9, 3.7280907429940033`*^9, 
   3.728169446568424*^9, 3.728169541724071*^9, 3.728169824254798*^9, 
   3.728169884294923*^9, 3.7282529567610817`*^9, 3.7289462573501*^9, 
   3.729022900837743*^9, 3.729119979791541*^9, 3.729121073594092*^9, 
   3.729121112049911*^9, 3.7291723088762493`*^9, 3.729175691909602*^9, 
   3.729175898527714*^9, 3.729183413214457*^9, {3.72918344855357*^9, 
   3.729183461458799*^9}, 3.7292559391231413`*^9, 3.729552302640155*^9, 
   3.7295578767316313`*^9, 3.729629839331705*^9, 3.729634637380622*^9, 
   3.7296428734670143`*^9, 3.729642909800926*^9, 3.7296439400116787`*^9, 
   3.729647186226632*^9, 3.729683245991271*^9, 3.72977817757222*^9, 
   3.7297792343175077`*^9, 3.729779281386825*^9, 3.7298947010192213`*^9, 
   3.7298960068269453`*^9, 
   3.729896153792561*^9},ExpressionUUID->"1c80014a-c38e-4d25-b1a8-\
4e47fad39fab"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["S Inverse", "Subsection",
 CellChangeTimes->{{3.7282461813905153`*^9, 
  3.728246183677311*^9}},ExpressionUUID->"883300ba-e7ed-4f38-ba6b-\
0e7f7a38512c"],

Cell["Bishop\[CloseCurlyQuote]s equation 1.72.", "Text",
 CellChangeTimes->{{3.727973854544991*^9, 3.727973958387879*^9}, {
  3.7279935391781883`*^9, 3.7279935616792603`*^9}, {3.7281702480246696`*^9, 
  3.7281702828359957`*^9}, {3.7291717549435673`*^9, 3.729171756365779*^9}, {
  3.729173508646914*^9, 
  3.7291735382601423`*^9}},ExpressionUUID->"27c93b4c-9606-4346-ab56-\
2f57deeaa0aa"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{"sInv", ",", "\[Alpha]", ",", "\[Beta]"}], "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"sInv", "[", 
    RowBox[{"\[Alpha]_", ",", "\[Beta]_", ",", "cs_", ",", "\[CapitalMu]_"}], 
    "]"}], ":=", "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"\[CapitalNu]", "=", 
       RowBox[{"Length", "[", "cs", "]"}]}], "}"}], ",", 
     "\[IndentingNewLine]", 
     RowBox[{
      RowBox[{"\[Alpha]", " ", 
       RowBox[{"IdentityMatrix", "[", 
        RowBox[{"\[CapitalMu]", "+", "1"}], "]"}]}], "+", 
      RowBox[{"\[Beta]", " ", 
       RowBox[{"Sum", "[", 
        RowBox[{
         RowBox[{
          RowBox[{
          "cs", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}], ".", 
          RowBox[{
           RowBox[{
           "cs", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}], 
           "\[Transpose]"}]}], ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", "\[CapitalNu]"}], "}"}]}], "]"}]}]}]}], "]"}]}], 
  ";"}]}], "Input",
 CellChangeTimes->{{3.727973884729273*^9, 3.727973893707472*^9}, {
   3.727973967319463*^9, 3.727973981031104*^9}, {3.727974108227893*^9, 
   3.72797411197365*^9}, {3.7279741548510723`*^9, 3.72797416892636*^9}, {
   3.7279748009815598`*^9, 3.727974944132066*^9}, {3.727974978991621*^9, 
   3.727975013741935*^9}, {3.727975044573173*^9, 3.727975082061253*^9}, {
   3.727975179449038*^9, 3.727975183788499*^9}, {3.727989511270849*^9, 
   3.727989517784666*^9}, {3.7279913069753647`*^9, 3.727991306982168*^9}, {
   3.727991851964892*^9, 3.727992057554862*^9}, {3.727992211691082*^9, 
   3.7279923598616533`*^9}, 3.728035965335248*^9, {3.72917351493624*^9, 
   3.729173515353211*^9}},ExpressionUUID->"680baf0e-7cff-46d2-810b-\
4e9f79446c8b"]
}, Open  ]],

Cell[CellGroupData[{

Cell["MAP Mean", "Subsection",
 CellChangeTimes->{{3.7282462270238667`*^9, 
  3.7282462292069902`*^9}},ExpressionUUID->"7504cef4-c129-460b-b81b-\
6105e1ea5faa"],

Cell["Bishop\[CloseCurlyQuote]s equation 1.70.", "Text",
 CellChangeTimes->{{3.7279935722104673`*^9, 3.727993577636578*^9}, {
   3.728252554798936*^9, 3.728252645286251*^9}, {3.729171771786726*^9, 
   3.72917177432257*^9}, 
   3.729182916782524*^9},ExpressionUUID->"6f8a63dc-0b9a-491f-8b1f-\
c838bdace2b0"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "mapMean", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"mapMean", "[", 
    RowBox[{
    "\[Alpha]_", ",", "\[Beta]_", ",", "x_", ",", "cs_", ",", "ts_", ",", 
     "\[CapitalMu]_"}], "]"}], ":=", "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"With", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"\[CapitalNu]", "=", 
        RowBox[{"Length", "@", "cs"}]}], "}"}], ",", "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"\[Beta]", "*", 
         RowBox[{
          RowBox[{"\[Phi]", "[", "\[CapitalMu]", "]"}], "[", "x", "]"}]}], 
        "}"}], ".", 
       RowBox[{"(*", " ", 
        RowBox[{"row", " ", "of", " ", "partials"}], " ", "*)"}], 
       "\[IndentingNewLine]", 
       RowBox[{"LinearSolve", "[", 
        RowBox[{"(*", " ", 
         RowBox[{"vector", " ", "of", " ", "coefficients"}], " ", "*)"}], 
        "\[IndentingNewLine]", 
        RowBox[{
         RowBox[{"sInv", "[", 
          RowBox[{
          "\[Alpha]", ",", "\[Beta]", ",", "cs", ",", "\[CapitalMu]"}], "]"}],
          ",", "\[IndentingNewLine]", 
         RowBox[{"ts", ".", "cs"}]}], "]"}]}]}], "]"}], 
    "\[LeftDoubleBracket]", 
    RowBox[{"1", ",", "1"}], "\[RightDoubleBracket]"}]}], ";"}]}], "Input",
 CellChangeTimes->{{3.727989096190207*^9, 3.727989111607684*^9}, {
   3.727989185580763*^9, 3.7279892393755693`*^9}, {3.72798955173129*^9, 
   3.727989594075267*^9}, {3.727989624561162*^9, 3.7279897672865*^9}, 
   3.727990207781111*^9, {3.7279902406039467`*^9, 3.727990276509069*^9}, {
   3.727990432145055*^9, 3.727990545195623*^9}, {3.72799130699829*^9, 
   3.727991307005333*^9}, {3.727991591768076*^9, 3.727991609737764*^9}, {
   3.727991645183196*^9, 3.72799166420612*^9}, {3.727992608834428*^9, 
   3.727992654156641*^9}, {3.7279927039199*^9, 3.7279927175692453`*^9}, {
   3.7279930333670883`*^9, 3.727993080952739*^9}, {3.727993138537717*^9, 
   3.727993147323758*^9}, {3.727993213160774*^9, 3.727993217820777*^9}, 
   3.728035955225011*^9, {3.7282262295415688`*^9, 3.728226243962159*^9}, {
   3.728226290221162*^9, 3.728226420069693*^9}, {3.728226502066142*^9, 
   3.728226526171074*^9}, {3.7282265682957487`*^9, 3.728226638371058*^9}, {
   3.728227010234784*^9, 3.7282270232238007`*^9}, {3.728245933205378*^9, 
   3.728245936365489*^9}, {3.7282459778757668`*^9, 3.728246022965337*^9}, {
   3.7282460585043507`*^9, 3.728246102733577*^9}, {3.7282462526429663`*^9, 
   3.728246318744425*^9}, {3.7282463492129383`*^9, 3.7282463559800463`*^9}, {
   3.728246442446768*^9, 3.728246466102882*^9}, {3.728246507569501*^9, 
   3.728246536388625*^9}, {3.728246579393989*^9, 3.7282466681208487`*^9}, {
   3.728247344958013*^9, 3.728247355611513*^9}, {3.7282474213422194`*^9, 
   3.728247422795175*^9}, {3.728247471143052*^9, 3.7282474904691353`*^9}, {
   3.728247907660754*^9, 3.7282479741618853`*^9}, {3.728248056332654*^9, 
   3.728248134124445*^9}, {3.728248164455634*^9, 3.7282481746776342`*^9}, 
   3.728248206633081*^9, {3.7282482403818007`*^9, 3.728248407583012*^9}, {
   3.728248438362019*^9, 3.72824858749609*^9}, {3.728248829569028*^9, 
   3.728249068639111*^9}, {3.728249133978136*^9, 3.7282492510926323`*^9}, 
   3.7282530152093763`*^9, {3.7282530485877857`*^9, 3.7282530512187223`*^9}, {
   3.72825308467808*^9, 3.7282531487824993`*^9}, {3.728253205404887*^9, 
   3.728253436301762*^9}, {3.72830462816504*^9, 3.7283050236694736`*^9}, {
   3.729177176419301*^9, 3.729177182963616*^9}, {3.729177255620264*^9, 
   3.729177269247582*^9}, 3.729177430853569*^9, {3.729177461134405*^9, 
   3.729177625835404*^9}, {3.7291776788725452`*^9, 3.729177737476037*^9}, {
   3.729177797007773*^9, 3.7291777980048656`*^9}, {3.7291783630299997`*^9, 
   3.72917836685954*^9}, {3.729179191155795*^9, 
   3.729179191813648*^9}},ExpressionUUID->"6a03cb85-7c1e-4eb7-aa65-\
7b2bc06e6962"]
}, Open  ]],

Cell[CellGroupData[{

Cell["A-Priori Variances \[Alpha] and \[Beta]", "Subsection",
 CellChangeTimes->{{3.729433856658804*^9, 3.7294338622133093`*^9}, {
  3.7296329364064617`*^9, 3.729632937814076*^9}, {3.7297178930877743`*^9, 
  3.729717894821443*^9}, {3.729792663995645*^9, 
  3.7297926706425962`*^9}},ExpressionUUID->"539b802e-4314-4a1d-8505-\
50bde2db22c0"],

Cell[TextData[{
 "Bishop defines ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Beta]", "=", 
    RowBox[{"1", "/", 
     SubsuperscriptBox["\[Sigma]", "\[Zeta]", "2"]}]}], TraditionalForm]],
  ExpressionUUID->"3cb59500-197e-4c4e-ac9f-4d98e4a2a78f"],
 ", where ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Sigma]", "\[Zeta]"], TraditionalForm]],ExpressionUUID->
  "4effa52e-3332-40b9-89db-fd17665a3169"],
 " is the standard deviation, from the model, of the prediction ",
 Cell[BoxData[
  FormBox["\[Zeta]", TraditionalForm]],ExpressionUUID->
  "d2430b71-8a16-463d-b08f-b4d69197671a"],
 ". The prediction ",
 Cell[BoxData[
  FormBox["\[Zeta]", TraditionalForm]],ExpressionUUID->
  "b4d5173e-78b5-4555-ba3f-38a350e58db3"],
 " is the value of the model on an arbitrary input ",
 Cell[BoxData[
  FormBox["\[Xi]", TraditionalForm]],ExpressionUUID->
  "c0efd558-47a6-464c-8219-11b4b7c12c31"],
 ". Similarly, Bishop defines ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Alpha]", "=", 
    RowBox[{"1", "/", 
     SubsuperscriptBox["\[Sigma]", "\[Xi]", "2"]}]}], TraditionalForm]],
  ExpressionUUID->"da801590-9053-4510-8f2d-61ce312277e8"],
 ", where ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["\[Sigma]", "\[Xi]"], TraditionalForm]],ExpressionUUID->
  "c3e1a099-1dc9-4e14-9310-78cf5ec0e7cf"],
 " is the standard deviation of the a-priori distribution of the unknown \
parameter estimate ",
 Cell[BoxData[
  FormBox["\[Xi]", TraditionalForm]],ExpressionUUID->
  "4cbca5ac-87c6-4cca-bb56-d89b90a797bf"],
 ". \n\nWe observe, numerically, that Bishop\[CloseCurlyQuote]s equations \
match RLS and KAL when ",
 Cell[BoxData[
  FormBox["\[Beta]", TraditionalForm]],ExpressionUUID->
  "79f416eb-30c7-45b8-8f29-c6b700475cbc"],
 " is ",
 Cell[BoxData[
  FormBox[
   SubsuperscriptBox["\[Sigma]", "\[Xi]", "2"], TraditionalForm]],
  ExpressionUUID->"4b490b01-f5f1-4c8b-a825-4654e9f817cb"],
 " and when ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Alpha]", "=", 
    SubsuperscriptBox["\[Sigma]", "\[Zeta]", "2"]}], TraditionalForm]],
  ExpressionUUID->"45fbcfcb-989e-462b-9f48-4d6edb33b0b7"],
 ". We leave full proof to another paper, being satisfied with numerical \
evidence here. \n\nSemi-numerically, the proposition is true (above order 4, \
The following becomes taxing for Mathematica):"
}], "Text",
 CellChangeTimes->CompressedData["
1:eJxTTMoPSmViYGAQA2IQHTp1TkzIydeOnH/eZoJob69/+SBaQNSkGUTXvurv
BNHPsqO7QPS8e/mLQXTTc8nVILr37431IFpqX98REH1L/lB2D5Depm+XA6JD
rjkVg+h9jtfLQTRP+vUzW4G0xqXXZ0H0gdrvN+4A6ZKQrMcguuDmi+cguqLg
1xsQ7bL5bsh9IP1F2CIURHM6zykD0Zvc5pWD6ANeK5tAtAtHXwuINni4++wf
IL3ISOsRiE5SUYv8B6QtZy5IBNENH5p7QPSfyx0TQHTC1NLK/yDze25Vg+iu
q9a9zKdeOz65KjMDRD9SMpwLoqccaVsIog3uRF4F0X9yFG6D6Ndh5Q9BtMWz
qicgOuKo2XU2IF0UbwOmAdt+z8w=
  
  "],ExpressionUUID->"b83890a5-a53b-45f1-a41f-d53e431dc82f"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", 
   RowBox[{"x", ",", "\[Alpha]", ",", "\[Beta]", ",", "chopQ"}], "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"DynamicModule", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"chopQ", "=", "False"}], "}"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Manipulate", "[", 
    RowBox[{
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"cs", "=", 
          RowBox[{
           RowBox[{"\[Phi]", "[", "\[CapitalMu]", "]"}], "/@", 
           RowBox[{"List", "/@", 
            RowBox[{
            "bts", "\[LeftDoubleBracket]", "1", 
             "\[RightDoubleBracket]"}]}]}]}], ",", 
         RowBox[{"ts", "=", 
          RowBox[{
          "bts", "\[LeftDoubleBracket]", "2", "\[RightDoubleBracket]"}]}]}], 
        "}"}], ",", "\[IndentingNewLine]", 
       RowBox[{
        RowBox[{"If", "[", 
         RowBox[{"chopQ", ",", "Chop", ",", "Identity"}], "]"}], "@", 
        RowBox[{"FullSimplify", "[", 
         RowBox[{
          RowBox[{"mapMean", "[", 
           RowBox[{
           "\[Alpha]", ",", "\[Beta]", ",", "x", ",", "cs", ",", "ts", ",", 
            "\[CapitalMu]"}], "]"}], "-", 
          RowBox[{"mapMean", "[", 
           RowBox[{
            FractionBox["1", "\[Beta]"], ",", 
            FractionBox["1", "\[Alpha]"], ",", "x", ",", "cs", ",", "ts", ",",
             "\[CapitalMu]"}], "]"}]}], "]"}]}]}], "]"}], ",", 
     "\[IndentingNewLine]", 
     RowBox[{"Column", "[", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"Row", "[", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"Button", "[", 
            RowBox[{"\"\<UN-CHOP\>\"", ",", 
             RowBox[{"chopQ", "=", "False"}]}], "]"}], ",", 
           "\"\<        \>\"", ",", "\[IndentingNewLine]", 
           RowBox[{"Button", "[", 
            RowBox[{"\"\<CHOP\>\"", ",", 
             RowBox[{"chopQ", "=", "True"}]}], "]"}]}], "}"}], "]"}], ",", 
        "\[IndentingNewLine]", 
        RowBox[{"Control", "[", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
            "\[CapitalMu]", ",", "2", ",", "\"\<order \[CapitalMu]\>\""}], 
            "}"}], ",", "0", ",", "4", ",", "1", ",", 
           RowBox[{"Appearance", "\[Rule]", 
            RowBox[{"{", 
             RowBox[{"\"\<Open\>\"", ",", "\"\<Labeled\>\""}], "}"}]}]}], 
          "}"}], "]"}]}], "}"}], "]"}]}], "]"}]}], "]"}]}], "Input",
 CellChangeTimes->{{3.727884681931381*^9, 3.7278848244947367`*^9}, 
   3.727884861217602*^9, {3.727884975910451*^9, 3.7278849940673532`*^9}, {
   3.727885103521431*^9, 3.727885154698123*^9}, {3.72788520225443*^9, 
   3.727885279820177*^9}, {3.727885496115718*^9, 3.727885517688189*^9}, {
   3.72788559395383*^9, 3.727885598972475*^9}, {3.7278856296542664`*^9, 
   3.727885630876935*^9}, {3.727885695972756*^9, 3.727885696864628*^9}, {
   3.727886633660364*^9, 3.72788671287046*^9}, {3.727886975364171*^9, 
   3.727886975439041*^9}, {3.727903476653379*^9, 3.7279034819231358`*^9}, {
   3.727903531862627*^9, 3.727903539245574*^9}, 3.727913149489944*^9, {
   3.727915429732944*^9, 3.7279154437948627`*^9}, {3.727915750998211*^9, 
   3.7279158447033873`*^9}, {3.7279213832695303`*^9, 3.72792149154887*^9}, {
   3.727921523149373*^9, 3.72792161270367*^9}, {3.72792165300301*^9, 
   3.727921654632832*^9}, {3.727921753282296*^9, 3.727921753360197*^9}, {
   3.727924008558401*^9, 3.727924045018003*^9}, {3.727924293814445*^9, 
   3.727924370827516*^9}, 3.727965590613636*^9, {3.7279686551525917`*^9, 
   3.727968670349081*^9}, {3.7279689406605043`*^9, 3.727969019631563*^9}, {
   3.727970883056108*^9, 3.727970945128386*^9}, {3.727971005813472*^9, 
   3.727971023734253*^9}, {3.727990640753121*^9, 3.727990674786282*^9}, {
   3.727990711779483*^9, 3.727990808626033*^9}, {3.727991307012423*^9, 
   3.727991307022031*^9}, {3.7279932412769613`*^9, 3.7279932949280367`*^9}, {
   3.7279933910397243`*^9, 3.727993398358789*^9}, {3.727993778490755*^9, 
   3.72799379332897*^9}, {3.727993826040863*^9, 3.7279938751552763`*^9}, {
   3.727993956673335*^9, 3.727993958184173*^9}, 3.727994128012043*^9, {
   3.7280354067714148`*^9, 3.7280354258611927`*^9}, {3.728035634299762*^9, 
   3.728035732029833*^9}, {3.72803585641748*^9, 3.728035906176405*^9}, {
   3.728038924314391*^9, 3.728039041653799*^9}, {3.728039077026232*^9, 
   3.72803913265169*^9}, {3.728039194847865*^9, 3.728039320044661*^9}, {
   3.728044256958378*^9, 3.728044343151896*^9}, {3.728044393583234*^9, 
   3.728044466540698*^9}, 3.7280447095836163`*^9, {3.728044856722988*^9, 
   3.728044959527645*^9}, {3.728044995179022*^9, 3.728044998104682*^9}, {
   3.728045028753289*^9, 3.728045063548128*^9}, {3.728045464570526*^9, 
   3.728045476328084*^9}, {3.728045812340419*^9, 3.728045836978776*^9}, {
   3.7280461335391397`*^9, 3.728046355530389*^9}, {3.728046392282709*^9, 
   3.728046397281275*^9}, {3.728046429888109*^9, 3.728046434285967*^9}, {
   3.728046509047914*^9, 3.728046577986915*^9}, {3.728048625582951*^9, 
   3.728048658147644*^9}, {3.728048704639155*^9, 3.7280487209829884`*^9}, {
   3.728048763333255*^9, 3.728048783520523*^9}, 3.728048849900649*^9, {
   3.728048881350296*^9, 3.7280488887365723`*^9}, {3.7280489358794527`*^9, 
   3.728048947834031*^9}, {3.7280492952517767`*^9, 3.728049427179392*^9}, {
   3.728049506853256*^9, 3.7280496162697783`*^9}, {3.728050015065921*^9, 
   3.7280500376507397`*^9}, {3.7280500733077374`*^9, 
   3.7280501005796213`*^9}, {3.728089881496944*^9, 3.728089882038129*^9}, {
   3.728090725835964*^9, 3.728090725845487*^9}, {3.728169349750301*^9, 
   3.728169349773612*^9}, {3.728169400997793*^9, 3.728169417906619*^9}, {
   3.728169511798567*^9, 3.728169523731205*^9}, {3.7281696125541363`*^9, 
   3.7281696306368437`*^9}, 3.728226727530678*^9, {3.728226810131266*^9, 
   3.728226816018466*^9}, {3.728226857072884*^9, 3.728226861119492*^9}, 
   3.728245946305786*^9, {3.7282487072286263`*^9, 3.728248709889584*^9}, {
   3.728251170478485*^9, 3.728251170709284*^9}, {3.7282526609079533`*^9, 
   3.728252718943617*^9}, 3.728252776351699*^9, {3.728252825506783*^9, 
   3.7282528275522842`*^9}, {3.7282528645183697`*^9, 3.728252865147182*^9}, 
   3.7282539826691*^9, {3.7291194284711437`*^9, 3.729119493281761*^9}, {
   3.7291195510227203`*^9, 3.729119680314639*^9}, {3.729119849724024*^9, 
   3.7291198585722113`*^9}, {3.7291717881457*^9, 3.729171818317573*^9}, {
   3.729171854440769*^9, 3.729171871385407*^9}, {3.72917192869256*^9, 
   3.7291720371346607`*^9}, {3.729173126976542*^9, 3.729173139435835*^9}, {
   3.729173200255974*^9, 3.729173275110746*^9}, {3.7291733458987417`*^9, 
   3.729173346264063*^9}, {3.729173389656439*^9, 3.729173389676496*^9}, {
   3.729173453362727*^9, 3.729173453374463*^9}, {3.72917500863538*^9, 
   3.729175053102626*^9}, {3.729175506297736*^9, 3.72917551618956*^9}, {
   3.729175643623238*^9, 3.729175648090048*^9}, {3.729176146733549*^9, 
   3.729176146742311*^9}, {3.729178985302376*^9, 3.729179018757811*^9}, {
   3.729179428316293*^9, 3.729179429546385*^9}, {3.729183394535775*^9, 
   3.729183394547886*^9}, {3.729190274999607*^9, 3.72919028248487*^9}, {
   3.729195946539386*^9, 3.729195963662328*^9}, {3.729256050052142*^9, 
   3.729256067693101*^9}, {3.729551202293354*^9, 3.7295512309957952`*^9}, {
   3.7296339987183323`*^9, 3.7296340585670023`*^9}, {3.72963414997302*^9, 
   3.7296342843671503`*^9}, {3.729634402705227*^9, 3.729634445056549*^9}, {
   3.729640374024897*^9, 3.7296403796236258`*^9}, {3.729640414581646*^9, 
   3.729640440813695*^9}, {3.729682825170733*^9, 3.729682850158277*^9}, {
   3.729687964822157*^9, 3.729687976272668*^9}, {3.729688124350306*^9, 
   3.729688350523089*^9}, {3.729688433189711*^9, 3.729688519693812*^9}, {
   3.7296888315942287`*^9, 3.729688853951269*^9}, {3.729688885214087*^9, 
   3.729688980761574*^9}, {3.729689047339793*^9, 3.72968904899368*^9}, {
   3.729689085039751*^9, 3.729689088321394*^9}, {3.729689126691318*^9, 
   3.729689162680344*^9}, {3.729689199269363*^9, 3.729689319536848*^9}, {
   3.7296894525051317`*^9, 3.7296895044680653`*^9}, {3.7296895377540073`*^9, 
   3.729689925517149*^9}, {3.729698780575644*^9, 3.7296988032889967`*^9}, {
   3.72969891708257*^9, 3.729698973930211*^9}, {3.729699028638085*^9, 
   3.729699670715773*^9}, {3.729699704631276*^9, 3.7296997129720783`*^9}, {
   3.729706992747849*^9, 3.729707001634725*^9}, {3.7297070524424753`*^9, 
   3.729707066383106*^9}, {3.7297071244821672`*^9, 3.729707137919736*^9}, {
   3.729707203038928*^9, 3.72970729917104*^9}, {3.729707646971855*^9, 
   3.729707660202389*^9}, {3.7297079419830017`*^9, 3.72970797164758*^9}, {
   3.729708009957337*^9, 3.729708049867004*^9}, {3.729708084939846*^9, 
   3.7297080920715303`*^9}, {3.729708515163211*^9, 3.729708569024414*^9}, {
   3.729708613027947*^9, 3.729708623070286*^9}, {3.729708794113842*^9, 
   3.729708805535737*^9}, {3.729710516671919*^9, 3.7297105167550173`*^9}, {
   3.729715343638529*^9, 3.729715514668886*^9}, {3.72971554649118*^9, 
   3.729715548641029*^9}, {3.729716174415708*^9, 3.7297162284181137`*^9}, {
   3.72971633922969*^9, 3.729716391073391*^9}, {3.729716434095726*^9, 
   3.7297164499844*^9}, {3.72971649749555*^9, 3.7297165316584883`*^9}, {
   3.7297165626756287`*^9, 3.72971664507301*^9}, 3.7297169348805857`*^9, {
   3.729717614590805*^9, 3.72971765727661*^9}, {3.729717764117723*^9, 
   3.729717812221105*^9}, {3.729775043049199*^9, 3.729775109731035*^9}, {
   3.729775163059536*^9, 3.7297751691054783`*^9}, {3.7297752542857*^9, 
   3.729775353153812*^9}, {3.729775426509468*^9, 3.729775439298881*^9}, {
   3.729775501959437*^9, 3.729775509498376*^9}, {3.7297756788539267`*^9, 
   3.729775889524164*^9}, {3.729775998285616*^9, 3.7297760435753508`*^9}, {
   3.729776079463018*^9, 3.72977609036007*^9}, {3.729782135519264*^9, 
   3.729782210852579*^9}, {3.7297822445658417`*^9, 3.729782365608235*^9}, {
   3.729782395984023*^9, 3.7297824531580763`*^9}, {3.729782495606496*^9, 
   3.729782567276868*^9}, {3.729782598609139*^9, 3.729782697457747*^9}, {
   3.729782728227727*^9, 3.7297827325418167`*^9}, {3.729782956333859*^9, 
   3.729782990916945*^9}, {3.7297830295719624`*^9, 3.7297830711784143`*^9}, {
   3.729783101922255*^9, 3.7297831604734583`*^9}, {3.729783202732057*^9, 
   3.7297832061980753`*^9}, {3.729783273985505*^9, 3.729783295285995*^9}, {
   3.729792821533854*^9, 
   3.7297928677603407`*^9}},ExpressionUUID->"d911fd00-b65e-46fb-8843-\
b073f43301ac"],

Cell[BoxData[
 DynamicModuleBox[{$CellContext`chopQ$$ = False}, 
  TagBox[
   StyleBox[
    DynamicModuleBox[{$CellContext`\[CapitalMu]$$ = 2, Typeset`show$$ = True, 
     Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
     Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
     "\"untitled\"", Typeset`specs$$ = {{{
        Hold[$CellContext`\[CapitalMu]$$], 2, "order \[CapitalMu]"}, 0, 4, 
       1}, {
       Hold[
        Column[{
          Row[{
            Button["UN-CHOP", $CellContext`chopQ$$ = False], "        ", 
            Button["CHOP", $CellContext`chopQ$$ = True]}], 
          Manipulate`Place[1]}]], Manipulate`Dump`ThisIsNotAControl}}, 
     Typeset`size$$ = {620.25, {151.69677734375, 16.}}, Typeset`update$$ = 0, 
     Typeset`initDone$$, Typeset`skipInitDone$$ = 
     True, $CellContext`\[CapitalMu]$3379$$ = 0}, 
     DynamicBox[Manipulate`ManipulateBoxes[
      2, StandardForm, "Variables" :> {$CellContext`\[CapitalMu]$$ = 2}, 
       "ControllerVariables" :> {
         Hold[$CellContext`\[CapitalMu]$$, $CellContext`\[CapitalMu]$3379$$, 
          0]}, "OtherVariables" :> {
        Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
         Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
         Typeset`specs$$, Typeset`size$$, Typeset`update$$, 
         Typeset`initDone$$, Typeset`skipInitDone$$}, "Body" :> 
       With[{$CellContext`cs$ = Map[
            $CellContext`\[Phi][$CellContext`\[CapitalMu]$$], 
            Map[List, 
             Part[$CellContext`bts, 1]]], $CellContext`ts$ = 
          Part[$CellContext`bts, 2]}, 
         If[$CellContext`chopQ$$, Chop, Identity][
          
          FullSimplify[$CellContext`mapMean[$CellContext`\[Alpha], \
$CellContext`\[Beta], $CellContext`x, $CellContext`cs$, $CellContext`ts$, \
$CellContext`\[CapitalMu]$$] - $CellContext`mapMean[
           1/$CellContext`\[Beta], 
            1/$CellContext`\[Alpha], $CellContext`x, $CellContext`cs$, \
$CellContext`ts$, $CellContext`\[CapitalMu]$$]]]], 
       "Specifications" :> {{{$CellContext`\[CapitalMu]$$, 2, 
           "order \[CapitalMu]"}, 0, 4, 1, Appearance -> {"Open", "Labeled"}, 
          ControlPlacement -> 1}, 
         Column[{
           Row[{
             Button["UN-CHOP", $CellContext`chopQ$$ = False], "        ", 
             Button["CHOP", $CellContext`chopQ$$ = True]}], 
           Manipulate`Place[1]}]}, "Options" :> {}, "DefaultOptions" :> {}],
      ImageSizeCache->{676., {171., 178.}},
      SingleEvaluation->True],
     Deinitialization:>None,
     DynamicModuleValues:>{},
     SynchronousInitialization->True,
     UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
     UnsavedVariables:>{Typeset`initDone$$},
     UntrackedVariables:>{Typeset`size$$}], "Manipulate",
    Deployed->True,
    StripOnInput->False],
   Manipulate`InterpretManipulate[1]],
  DynamicModuleValues:>{}]], "Output",
 CellChangeTimes->{
  3.7297782657737503`*^9, 3.729779234914673*^9, 3.729779309463353*^9, 
   3.729782169097911*^9, 3.729782212385736*^9, 3.729782264223064*^9, {
   3.729782321149456*^9, 3.729782334713049*^9}, {3.729782366911766*^9, 
   3.729782409837133*^9}, 3.729782456605835*^9, 3.729782570409789*^9, {
   3.729782606279397*^9, 3.729782640383834*^9}, {3.729782699444137*^9, 
   3.729782733551096*^9}, {3.7297829709597683`*^9, 3.729782991922044*^9}, {
   3.729783051941214*^9, 3.729783072104805*^9}, {3.729783103752767*^9, 
   3.729783162251648*^9}, 3.72978321464939*^9, 3.729783296029469*^9, {
   3.729792849257351*^9, 3.729792868783079*^9}, 3.7298947011281157`*^9, 
   3.729896006909101*^9, 
   3.729896153898386*^9},ExpressionUUID->"79648570-282c-43af-90ae-\
c6ef62ebda84"]
}, Open  ]],

Cell[TextData[{
 "The other two combinations, where ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Beta]", "=", 
    RowBox[{
     RowBox[{
      RowBox[{"1", "/", 
       SubsuperscriptBox["\[Sigma]", "\[Zeta]", "2"]}], " ", "\[Wedge]", " ", 
      "\[Alpha]"}], "=", 
     SubsuperscriptBox["\[Sigma]", "\[Zeta]", "2"]}]}], TraditionalForm]],
  ExpressionUUID->"3c8c5deb-108d-43ab-9803-c6eeaa41be5a"],
 " or ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Beta]", "=", 
    RowBox[{
     RowBox[{
      SubsuperscriptBox["\[Sigma]", "\[Xi]", "2"], " ", "\[Wedge]", " ", 
      "\[Alpha]"}], "=", 
     RowBox[{"1", "/", 
      SubsuperscriptBox["\[Sigma]", "\[Xi]", "2"]}]}]}], TraditionalForm]],
  ExpressionUUID->"091d4ea1-9899-4f40-8494-d4a5560376dc"],
 " are not correct. Intuitively, these two combinations do not contain full \
information about the a-priori beliefs in both ",
 Cell[BoxData[
  FormBox["\[Zeta]", TraditionalForm]],ExpressionUUID->
  "25c9f435-1258-4111-ae97-95819c0dc110"],
 " and ",
 Cell[BoxData[
  FormBox["\[Xi]", TraditionalForm]],ExpressionUUID->
  "f2270d0c-8d5e-48db-beb9-f5b6e221e6c1"],
 ", so we do not expect them to be correct. This fact can be demonstrated \
numerically.\n\nIn the following demonstration, the numerical evidence for \
equality of the two applications of MAP becomes overwhelming. MAP, RLS, and \
KAL match for all settings of ",
 Cell[BoxData[
  FormBox[
   SubsuperscriptBox["\[Sigma]", "\[Xi]", "2"], TraditionalForm]],
  ExpressionUUID->"43777bf0-347f-4339-a30b-caaca26375ea"],
 ", ",
 Cell[BoxData[
  FormBox[
   SubsuperscriptBox["\[Sigma]", "\[Zeta]", "2"], TraditionalForm]],
  ExpressionUUID->"03f7d140-bb9e-4b49-a90c-93d03643da4e"],
 ", ",
 Cell[BoxData[
  FormBox["\[CapitalMu]", TraditionalForm]],ExpressionUUID->
  "4e14f357-6e1d-4562-a503-d8a33ad79b0d"],
 " (order of the model), and assignments of ",
 Cell[BoxData[
  FormBox["\[Alpha]", TraditionalForm]],ExpressionUUID->
  "6d988ecb-a118-4856-94a5-c1b3425efc15"],
 " and ",
 Cell[BoxData[
  FormBox["\[Beta]", TraditionalForm]],ExpressionUUID->
  "f755a1b1-ab8a-4891-9c0e-de8f6f0c9f59"],
 ". The one deviation from perfect match concerns KAL. Explore the case where \
the order is around ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[CapitalMu]", "=", "4"}], TraditionalForm]],ExpressionUUID->
  "427b4264-a2e3-4974-a79b-bd1e22d45410"],
 ". For high ",
 Cell[BoxData[
  FormBox[
   SubsuperscriptBox["\[Sigma]", "\[Xi]", "2"], TraditionalForm]],
  ExpressionUUID->"6138c40a-4c79-4f97-88b0-ea1e16441c42"],
 " (don\[CloseCurlyQuote]t believe the a-priori estimate of ",
 Cell[BoxData[
  FormBox["\[Xi]", TraditionalForm]],ExpressionUUID->
  "8ede57ef-973c-4114-bf65-08adc80e2d22"],
 ") and low ",
 Cell[BoxData[
  FormBox[
   SubsuperscriptBox["\[Sigma]", "\[Zeta]z", "2"], TraditionalForm]],
  ExpressionUUID->"976c4626-4857-4fb0-9890-7e1c2c476242"],
 " (",
 StyleBox["do",
  FontSlant->"Italic"],
 " believe the observational data), KAL fluctuates wildly. Why? The Kalman \
denominator ",
 Cell[BoxData[
  FormBox[
   RowBox[{"D", "=", 
    RowBox[{
     SubscriptBox["P", "\[Zeta]"], "+", 
     RowBox[{
      RowBox[{"a", "\[Transpose]"}], 
      SubscriptBox["P", "\[Xi]"], "a"}]}]}], TraditionalForm]],
  ExpressionUUID->"f370fac0-c8e6-480a-bb39-fa1c564318d6"],
 " becomes nearly ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"a", "\[Transpose]"}], 
    SubscriptBox["P", "\[Xi]"], "a"}], TraditionalForm]],ExpressionUUID->
  "a6bc1f16-0b8a-4d78-b8ca-1ec54345ea34"],
 ". The Kalman gain, ",
 Cell[BoxData[
  FormBox[
   RowBox[{"K", "=", 
    RowBox[{
     SubscriptBox["P", "\[Xi]"], " ", 
     RowBox[{"a", "\[Transpose]"}], 
     SuperscriptBox["D", 
      RowBox[{"-", "1"}]]}]}], TraditionalForm]],ExpressionUUID->
  "67d8e535-dd07-4789-8b7e-d765ef3ab24d"],
 " is nearly ",
 Cell[BoxData[
  FormBox[
   SuperscriptBox["a", 
    RowBox[{"-", "1"}]], TraditionalForm]],ExpressionUUID->
  "bc26f308-cc73-4f74-99c5-b2cd9c9df669"],
 ". The covariance update, ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{"(", 
     RowBox[{"I", "-", 
      RowBox[{"K", " ", "a"}]}], ")"}], "\[CenterDot]", "P"}], 
   TraditionalForm]],ExpressionUUID->"507f8d85-dc1a-442b-8c74-d6548ac0649a"],
 ", becomes ill-conditioned, if not negative, because ",
 Cell[BoxData[
  FormBox[
   RowBox[{"K", " ", "a"}], TraditionalForm]],ExpressionUUID->
  "2f1be427-a6af-4e70-ba49-a962269a03ad"],
 " is near unity. \n\nRenormalized RLS does not suffer from these ills \
because it never subtracts. Renormalized RLS is still exposed to \
ill-conditioning of the information matrix, but that seems numerically to be \
less harmful to the final result. We wrap RLS in ",
 Cell[BoxData[
  FormBox["Quiet", TraditionalForm]], "Code",ExpressionUUID->
  "5bc2626d-10d1-4129-a6ff-b0cfb809366f"],
 " to suppress warnings. There is no free lunch; MAP also shows \
ill-conditioning and is similarly wrapped."
}], "Text",
 CellChangeTimes->{{3.729783790020461*^9, 3.729783833800892*^9}, {
  3.729792752988352*^9, 3.729792754474485*^9}, {3.72979292818992*^9, 
  3.729793090930941*^9}, {3.7297931436578207`*^9, 3.729793265017269*^9}, {
  3.729793300332588*^9, 3.729793320164184*^9}, {3.7297988561592207`*^9, 
  3.729798964992071*^9}},ExpressionUUID->"586406c3-dd60-45ee-b931-\
47618b95d6e7"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "rrlsFit", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{"rrlsFit", "[", 
     RowBox[{"\[Sigma]2\[Zeta]_", ",", "\[Sigma]2\[Xi]_"}], "]"}], "[", 
    RowBox[{"\[CapitalMu]_", ",", "trainingSet_"}], "]"}], ":=", 
   "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"xs", "=", 
        RowBox[{
        "trainingSet", "\[LeftDoubleBracket]", "1", 
         "\[RightDoubleBracket]"}]}], ",", 
       RowBox[{"ys", "=", 
        RowBox[{
        "trainingSet", "\[LeftDoubleBracket]", "2", 
         "\[RightDoubleBracket]"}]}]}], "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"\[Xi]0", "=", 
          RowBox[{"List", "/@", 
           RowBox[{"ConstantArray", "[", 
            RowBox[{"0", ",", 
             RowBox[{"\[CapitalMu]", "+", "1"}]}], "]"}]}]}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"\[CapitalLambda]0", "=", 
          RowBox[{
           SuperscriptBox["\[Sigma]2\[Xi]", 
            RowBox[{"-", "1"}]], "*", 
           RowBox[{"IdentityMatrix", "[", 
            RowBox[{"\[CapitalMu]", "+", "1"}], "]"}]}]}]}], "}"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"Module", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{"\[Xi]", ",", "\[CapitalLambda]"}], "}"}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{
          RowBox[{
           RowBox[{"{", 
            RowBox[{"\[Xi]", ",", "\[CapitalLambda]"}], "}"}], "=", 
           RowBox[{"Fold", "[", "\[IndentingNewLine]", 
            RowBox[{
             RowBox[{"rlsUpdate", "[", 
              RowBox[{
               SqrtBox["\[Sigma]2\[Zeta]"], " ", 
               RowBox[{"IdentityMatrix", "[", "1", "]"}]}], "]"}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{"{", 
              RowBox[{"\[Xi]0", ",", "\[CapitalLambda]0"}], "}"}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{
                RowBox[{"List", "/@", "ys"}], ",", 
                RowBox[{"List", "/@", 
                 RowBox[{"partialsFn", "[", 
                  RowBox[{"\[CapitalMu]", ",", "xs"}], "]"}]}]}], "}"}], 
              "\[Transpose]"}]}], "]"}]}], ";", "\[IndentingNewLine]", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"\[Xi]", "/", 
             SqrtBox["\[Sigma]2\[Zeta]"]}], ",", "\[CapitalLambda]"}], 
           "}"}]}]}], "]"}]}], "]"}]}], "]"}]}], ";"}]}], "Input",
 CellChangeTimes->{
  3.729633130001239*^9, {3.729633467830708*^9, 3.729633492149434*^9}, {
   3.7296337563259163`*^9, 3.729633881138937*^9}, {3.729634078099366*^9, 
   3.729634114632291*^9}, {3.729634488868413*^9, 3.729634543490809*^9}, {
   3.729634604318096*^9, 3.729634609788732*^9}, {3.729634698866778*^9, 
   3.7296346994928493`*^9}, {3.729634739708737*^9, 3.729634753142261*^9}, {
   3.729634799344757*^9, 3.7296347996478977`*^9}, {3.729634920657688*^9, 
   3.729634927950851*^9}, {3.729634993197016*^9, 3.729635007292894*^9}, {
   3.729640041813924*^9, 3.729640137924788*^9}, {3.72964025016105*^9, 
   3.729640319535129*^9}, {3.7296827987466717`*^9, 3.729682819296286*^9}, {
   3.729683287333426*^9, 
   3.729683287716338*^9}},ExpressionUUID->"f438e33b-fa2b-4bdc-a27a-\
eefd45f72ad4"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"DynamicModule", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"\[Alpha]\[Beta]Bishop", "=", "True"}], "}"}], ",", 
   "\[IndentingNewLine]", 
   RowBox[{"Manipulate", "[", 
    RowBox[{
     RowBox[{"Module", "[", 
      RowBox[{
       RowBox[{"{", "x", "}"}], ",", "\[IndentingNewLine]", 
       RowBox[{"With", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"terms", "=", 
            RowBox[{"symbolicPowers", "[", 
             RowBox[{"x", ",", "\[CapitalMu]"}], "]"}]}], ",", 
           RowBox[{"cs", "=", 
            RowBox[{
             RowBox[{"\[Phi]", "[", "\[CapitalMu]", "]"}], "/@", 
             RowBox[{"List", "/@", 
              RowBox[{
              "bts", "\[LeftDoubleBracket]", "1", 
               "\[RightDoubleBracket]"}]}]}]}], ",", 
           RowBox[{"ts", "=", 
            RowBox[{
            "bts", "\[LeftDoubleBracket]", "2", "\[RightDoubleBracket]"}]}], 
           ",", 
           RowBox[{"\[Sigma]\[Zeta]2", "=", 
            SuperscriptBox["10.", 
             RowBox[{"2", "log\[Sigma]\[Zeta]"}]]}], ",", 
           RowBox[{"\[Sigma]\[Xi]2", "=", 
            SuperscriptBox["10.", 
             RowBox[{"2", "log\[Sigma]\[Xi]"}]]}]}], "}"}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"With", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{"normal", "=", 
              RowBox[{"mleFit", "[", 
               RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{"kalman", "=", 
              RowBox[{
               RowBox[{"kalFit", "[", 
                RowBox[{"\[Sigma]\[Zeta]2", ",", "\[Sigma]\[Xi]2"}], "]"}], 
               "[", 
               RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{"rrls", "=", 
              RowBox[{"Quiet", "@", 
               RowBox[{
                RowBox[{"rrlsFit", "[", 
                 RowBox[{"\[Sigma]\[Zeta]2", ",", "\[Sigma]\[Xi]2"}], "]"}], 
                "[", 
                RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}]}]}], "}"}], ",",
            "\[IndentingNewLine]", 
           RowBox[{"With", "[", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{
               RowBox[{"\[Alpha]", "=", 
                RowBox[{"If", "[", 
                 RowBox[{"\[Alpha]\[Beta]Bishop", ",", 
                  FractionBox["1", "\[Sigma]\[Xi]2"], ",", 
                  "\[Sigma]\[Zeta]2"}], "]"}]}], ",", 
               RowBox[{"\[Beta]", "=", 
                RowBox[{"If", "[", 
                 RowBox[{"\[Alpha]\[Beta]Bishop", ",", 
                  FractionBox["1", "\[Sigma]\[Zeta]2"], ",", 
                  "\[Sigma]\[Xi]2"}], "]"}]}]}], "}"}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{"With", "[", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"mleFn", "=", 
                  RowBox[{"terms", ".", "normal"}]}], ",", 
                 "\[IndentingNewLine]", 
                 RowBox[{"kalFn", "=", 
                  RowBox[{
                   RowBox[{"{", "terms", "}"}], ".", 
                   RowBox[{
                   "kalman", "\[LeftDoubleBracket]", "1", 
                    "\[RightDoubleBracket]"}]}]}], ",", "\[IndentingNewLine]", 
                 RowBox[{"mapFn", "=", 
                  RowBox[{"Quiet", "@", 
                   RowBox[{"mapMean", "[", 
                    RowBox[{
                    "\[Alpha]", ",", "\[Beta]", ",", "x", ",", "cs", ",", 
                    "ts", ",", "\[CapitalMu]"}], "]"}]}]}], ",", 
                 "\[IndentingNewLine]", 
                 RowBox[{"rlsFn", "=", 
                  RowBox[{
                   RowBox[{"{", "terms", "}"}], ".", 
                   RowBox[{
                   "rrls", "\[LeftDoubleBracket]", "1", 
                    "\[RightDoubleBracket]"}]}]}]}], "}"}], ",", 
               "\[IndentingNewLine]", 
               RowBox[{"With", "[", 
                RowBox[{
                 RowBox[{"{", 
                  RowBox[{"lp", "=", 
                   RowBox[{"ListPlot", "[", 
                    RowBox[{
                    RowBox[{"bts", "\[Transpose]"}], ",", 
                    "\[IndentingNewLine]", 
                    RowBox[{"PlotMarkers", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"Graphics", "@", 
                    RowBox[{"{", 
                    RowBox[{"Blue", ",", 
                    RowBox[{"Circle", "[", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"0", ",", "0"}], "}"}], ",", "1"}], "]"}]}], 
                    "}"}]}], ",", ".05"}], "}"}]}]}], "]"}]}], "}"}], ",", 
                 "\[IndentingNewLine]", 
                 RowBox[{"Module", "[", 
                  RowBox[{
                   RowBox[{"{", 
                    RowBox[{"showlist", "=", 
                    RowBox[{"{", 
                    RowBox[{"lp", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox[
                    RowBox[{"Sin", "[", 
                    RowBox[{"2.", "\[Pi]", " ", "x"}], "]"}],
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0.", ",", "1."}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"Thick", ",", 
                    StyleBox["Green",
                    Background->RGBColor[1, 1, 0]]}], "}"}]}]}], "]"}]}], 
                    "}"}]}], "}"}], ",", "\[IndentingNewLine]", 
                   RowBox[{
                    RowBox[{"If", "[", 
                    RowBox[{"mleQ", ",", 
                    RowBox[{"AppendTo", "[", 
                    RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["mleFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Orange",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                    "]"}]}], "]"}], ";", "\[IndentingNewLine]", 
                    RowBox[{"If", "[", 
                    RowBox[{"rlsQ", ",", 
                    RowBox[{"AppendTo", "[", 
                    RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["rlsFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Purple",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                    "]"}]}], "]"}], ";", 
                    RowBox[{"If", "[", 
                    RowBox[{"kalQ", ",", 
                    RowBox[{"AppendTo", "[", 
                    RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["kalFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Cyan",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                    "]"}]}], "]"}], ";", "\[IndentingNewLine]", 
                    RowBox[{"If", "[", 
                    RowBox[{"mapQ", ",", 
                    RowBox[{"AppendTo", "[", 
                    RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    StyleBox["mapFn",
                    Background->RGBColor[1, 1, 0]], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    StyleBox["Magenta",
                    Background->RGBColor[1, 1, 0]], "}"}]}]}], "]"}]}], 
                    "]"}]}], "]"}], ";", "\[IndentingNewLine]", 
                    RowBox[{"Quiet", "@", 
                    RowBox[{"Show", "[", 
                    RowBox[{"showlist", ",", 
                    RowBox[{"Frame", "\[Rule]", "True"}], ",", 
                    RowBox[{"ImageSize", "\[Rule]", "Medium"}], ",", 
                    RowBox[{"FrameLabel", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"\"\<\[Zeta]\>\"", ",", "\"\<\>\""}], "}"}], ",", 
                    
                    RowBox[{"{", 
                    RowBox[{"\"\<\[Xi]\>\"", ",", 
                    RowBox[{"Grid", "[", 
                    RowBox[{"{", 
                    RowBox[{"{", 
                    RowBox[{
                    "\"\<\[Alpha]: \>\"", ",", "\[Alpha]", ",", 
                    "\"\<\[Beta]:\>\"", ",", "\[Beta]"}], "}"}], "}"}], 
                    "]"}]}], "\[IndentingNewLine]", "}"}]}], "}"}]}]}], 
                    "]"}]}]}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}], 
        "]"}]}], "]"}], ",", "\[IndentingNewLine]", 
     RowBox[{"Column", "[", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"SetterBar", "[", 
         RowBox[{
          RowBox[{"Dynamic", "[", "\[Alpha]\[Beta]Bishop", "]"}], ",", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{
            "True", "\[Rule]", 
             "\"\<\[Alpha] = \!\(\*FractionBox[\(1\), SubsuperscriptBox[\(\
\[Sigma]\), \(\[Xi]\), \(2\)]]\), \[Beta] = \!\(\*FractionBox[\(1\), \
SubsuperscriptBox[\(\[Sigma]\), \(\[Zeta]\), \(2\)]]\)\>\""}], ",", 
            RowBox[{
            "False", "\[Rule]", 
             "\"\<\[Alpha] = \!\(\*SubsuperscriptBox[\(\[Sigma]\), \
\(\[Zeta]\), \(2\)]\), \[Beta] = \!\(\*SubsuperscriptBox[\(\[Sigma]\), \
\(\[Xi]\), \(2\)]\)\>\""}]}], "}"}]}], "]"}], ",", "\[IndentingNewLine]", 
        RowBox[{"Row", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{"Button", "[", 
             RowBox[{"\"\<RESET\>\"", ",", 
              RowBox[{
               RowBox[{"(", 
                RowBox[{
                 RowBox[{"\[CapitalMu]", "=", "4"}], ";", 
                 RowBox[{"log\[Sigma]\[Xi]", "=", ".5"}], ";", 
                 RowBox[{"log\[Sigma]\[Zeta]", "=", 
                  RowBox[{"-", "1.5"}]}]}], ")"}], "&"}]}], "]"}], ",", 
            "\[IndentingNewLine]", 
            RowBox[{"Control", "[", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"kalQ", ",", "True", ",", "\"\<        KAL\>\""}], 
                "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}], ",", 
            "\[IndentingNewLine]", 
            RowBox[{"Control", "[", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"rlsQ", ",", "True", ",", "\"\<        RLS\>\""}], 
                "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}], ",", 
            "\[IndentingNewLine]", 
            RowBox[{"Control", "[", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"mleQ", ",", "False", ",", "\"\<        MLE\>\""}], 
                "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}], ",", 
            "\[IndentingNewLine]", 
            RowBox[{"Control", "[", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"mapQ", ",", "True", ",", "\"\<        MAP\>\""}], 
                "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}]}], 
           "}"}], ",", 
          RowBox[{"Frame", "\[Rule]", "All"}]}], "]"}], ",", 
        "\[IndentingNewLine]", 
        RowBox[{"Control", "[", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
            "\[CapitalMu]", ",", "4", ",", "\"\<order \[CapitalMu]\>\""}], 
            "}"}], ",", "0", ",", "16", ",", "1", ",", 
           RowBox[{"Appearance", "\[Rule]", 
            RowBox[{"{", "\"\<Labeled\>\"", "}"}]}]}], "}"}], "]"}], ",", 
        RowBox[{"Control", "[", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
            "log\[Sigma]\[Xi]", ",", ".5", ",", 
             "\"\<log \[Sigma]\[Xi] (KAL)\>\""}], "}"}], ",", 
           RowBox[{"-", "3"}], ",", " ", "5", ",", 
           RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], 
         "]"}], ",", "\[IndentingNewLine]", 
        RowBox[{"Control", "[", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{"log\[Sigma]\[Zeta]", ",", 
             RowBox[{"-", "1.5"}], ",", "\"\<log \[Sigma]\[Zeta] (KAL)\>\""}],
             "}"}], ",", 
           RowBox[{"-", "7"}], ",", "3", ",", 
           RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], 
         "]"}]}], "}"}], "]"}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.727884681931381*^9, 3.7278848244947367`*^9}, 
   3.727884861217602*^9, {3.727884975910451*^9, 3.7278849940673532`*^9}, {
   3.727885103521431*^9, 3.727885154698123*^9}, {3.72788520225443*^9, 
   3.727885279820177*^9}, {3.727885496115718*^9, 3.727885517688189*^9}, {
   3.72788559395383*^9, 3.727885598972475*^9}, {3.7278856296542664`*^9, 
   3.727885630876935*^9}, {3.727885695972756*^9, 3.727885696864628*^9}, {
   3.727886633660364*^9, 3.72788671287046*^9}, {3.727886975364171*^9, 
   3.727886975439041*^9}, {3.727903476653379*^9, 3.7279034819231358`*^9}, {
   3.727903531862627*^9, 3.727903539245574*^9}, 3.727913149489944*^9, {
   3.727915429732944*^9, 3.7279154437948627`*^9}, {3.727915750998211*^9, 
   3.7279158447033873`*^9}, {3.7279213832695303`*^9, 3.72792149154887*^9}, {
   3.727921523149373*^9, 3.72792161270367*^9}, {3.72792165300301*^9, 
   3.727921654632832*^9}, {3.727921753282296*^9, 3.727921753360197*^9}, {
   3.727924008558401*^9, 3.727924045018003*^9}, {3.727924293814445*^9, 
   3.727924370827516*^9}, 3.727965590613636*^9, {3.7279686551525917`*^9, 
   3.727968670349081*^9}, {3.7279689406605043`*^9, 3.727969019631563*^9}, {
   3.727970883056108*^9, 3.727970945128386*^9}, {3.727971005813472*^9, 
   3.727971023734253*^9}, {3.727990640753121*^9, 3.727990674786282*^9}, {
   3.727990711779483*^9, 3.727990808626033*^9}, {3.727991307012423*^9, 
   3.727991307022031*^9}, {3.7279932412769613`*^9, 3.7279932949280367`*^9}, {
   3.7279933910397243`*^9, 3.727993398358789*^9}, {3.727993778490755*^9, 
   3.72799379332897*^9}, {3.727993826040863*^9, 3.7279938751552763`*^9}, {
   3.727993956673335*^9, 3.727993958184173*^9}, 3.727994128012043*^9, {
   3.7280354067714148`*^9, 3.7280354258611927`*^9}, {3.728035634299762*^9, 
   3.728035732029833*^9}, {3.72803585641748*^9, 3.728035906176405*^9}, {
   3.728038924314391*^9, 3.728039041653799*^9}, {3.728039077026232*^9, 
   3.72803913265169*^9}, {3.728039194847865*^9, 3.728039320044661*^9}, {
   3.728044256958378*^9, 3.728044343151896*^9}, {3.728044393583234*^9, 
   3.728044466540698*^9}, 3.7280447095836163`*^9, {3.728044856722988*^9, 
   3.728044959527645*^9}, {3.728044995179022*^9, 3.728044998104682*^9}, {
   3.728045028753289*^9, 3.728045063548128*^9}, {3.728045464570526*^9, 
   3.728045476328084*^9}, {3.728045812340419*^9, 3.728045836978776*^9}, {
   3.7280461335391397`*^9, 3.728046355530389*^9}, {3.728046392282709*^9, 
   3.728046397281275*^9}, {3.728046429888109*^9, 3.728046434285967*^9}, {
   3.728046509047914*^9, 3.728046577986915*^9}, {3.728048625582951*^9, 
   3.728048658147644*^9}, {3.728048704639155*^9, 3.7280487209829884`*^9}, {
   3.728048763333255*^9, 3.728048783520523*^9}, 3.728048849900649*^9, {
   3.728048881350296*^9, 3.7280488887365723`*^9}, {3.7280489358794527`*^9, 
   3.728048947834031*^9}, {3.7280492952517767`*^9, 3.728049427179392*^9}, {
   3.728049506853256*^9, 3.7280496162697783`*^9}, {3.728050015065921*^9, 
   3.7280500376507397`*^9}, {3.7280500733077374`*^9, 
   3.7280501005796213`*^9}, {3.728089881496944*^9, 3.728089882038129*^9}, {
   3.728090725835964*^9, 3.728090725845487*^9}, {3.728169349750301*^9, 
   3.728169349773612*^9}, {3.728169400997793*^9, 3.728169417906619*^9}, {
   3.728169511798567*^9, 3.728169523731205*^9}, {3.7281696125541363`*^9, 
   3.7281696306368437`*^9}, 3.728226727530678*^9, {3.728226810131266*^9, 
   3.728226816018466*^9}, {3.728226857072884*^9, 3.728226861119492*^9}, 
   3.728245946305786*^9, {3.7282487072286263`*^9, 3.728248709889584*^9}, {
   3.728251170478485*^9, 3.728251170709284*^9}, {3.7282526609079533`*^9, 
   3.728252718943617*^9}, 3.728252776351699*^9, {3.728252825506783*^9, 
   3.7282528275522842`*^9}, {3.7282528645183697`*^9, 3.728252865147182*^9}, 
   3.7282539826691*^9, {3.7291194284711437`*^9, 3.729119493281761*^9}, {
   3.7291195510227203`*^9, 3.729119680314639*^9}, {3.729119849724024*^9, 
   3.7291198585722113`*^9}, {3.7291717881457*^9, 3.729171818317573*^9}, {
   3.729171854440769*^9, 3.729171871385407*^9}, {3.72917192869256*^9, 
   3.7291720371346607`*^9}, {3.729173126976542*^9, 3.729173139435835*^9}, {
   3.729173200255974*^9, 3.729173275110746*^9}, {3.7291733458987417`*^9, 
   3.729173346264063*^9}, {3.729173389656439*^9, 3.729173389676496*^9}, {
   3.729173453362727*^9, 3.729173453374463*^9}, {3.72917500863538*^9, 
   3.729175053102626*^9}, {3.729175506297736*^9, 3.72917551618956*^9}, {
   3.729175643623238*^9, 3.729175648090048*^9}, {3.729176146733549*^9, 
   3.729176146742311*^9}, {3.729178985302376*^9, 3.729179018757811*^9}, {
   3.729179428316293*^9, 3.729179429546385*^9}, {3.729183394535775*^9, 
   3.729183394547886*^9}, {3.729190274999607*^9, 3.72919028248487*^9}, {
   3.729195946539386*^9, 3.729195963662328*^9}, {3.729256050052142*^9, 
   3.729256067693101*^9}, {3.729551202293354*^9, 3.7295512309957952`*^9}, {
   3.7296339987183323`*^9, 3.7296340585670023`*^9}, {3.72963414997302*^9, 
   3.7296342843671503`*^9}, {3.729634402705227*^9, 3.729634445056549*^9}, {
   3.729640374024897*^9, 3.7296403796236258`*^9}, {3.729640414581646*^9, 
   3.729640440813695*^9}, {3.729682825170733*^9, 3.729682850158277*^9}, {
   3.729687964822157*^9, 3.729687976272668*^9}, {3.729688124350306*^9, 
   3.729688350523089*^9}, {3.729688433189711*^9, 3.729688519693812*^9}, {
   3.7296888315942287`*^9, 3.729688853951269*^9}, {3.729688885214087*^9, 
   3.729688980761574*^9}, {3.729689047339793*^9, 3.72968904899368*^9}, {
   3.729689085039751*^9, 3.729689088321394*^9}, {3.729689126691318*^9, 
   3.729689162680344*^9}, {3.729689199269363*^9, 3.729689319536848*^9}, {
   3.7296894525051317`*^9, 3.7296895044680653`*^9}, {3.7296895377540073`*^9, 
   3.729689925517149*^9}, {3.729698780575644*^9, 3.7296988032889967`*^9}, {
   3.72969891708257*^9, 3.729698973930211*^9}, {3.729699028638085*^9, 
   3.729699670715773*^9}, {3.729699704631276*^9, 3.7296997129720783`*^9}, {
   3.729706992747849*^9, 3.729707001634725*^9}, {3.7297070524424753`*^9, 
   3.729707066383106*^9}, {3.7297071244821672`*^9, 3.729707137919736*^9}, {
   3.729707203038928*^9, 3.72970729917104*^9}, {3.729707646971855*^9, 
   3.729707660202389*^9}, {3.7297079419830017`*^9, 3.72970797164758*^9}, {
   3.729708009957337*^9, 3.729708049867004*^9}, {3.729708084939846*^9, 
   3.7297080920715303`*^9}, {3.729708515163211*^9, 3.729708569024414*^9}, {
   3.729708613027947*^9, 3.729708623070286*^9}, {3.729708794113842*^9, 
   3.729708805535737*^9}, {3.729710516671919*^9, 3.7297105167550173`*^9}, {
   3.729784342249545*^9, 3.7297847167390738`*^9}, {3.729784762209856*^9, 
   3.7297847785042458`*^9}, {3.729784818040599*^9, 3.7297849058292437`*^9}, {
   3.729784947378476*^9, 3.7297849866650257`*^9}, {3.729790334304122*^9, 
   3.7297904006081543`*^9}, {3.7297904543011217`*^9, 3.729790469826312*^9}, {
   3.729790510736865*^9, 3.729790515646512*^9}, {3.729790569437749*^9, 
   3.729790630375985*^9}, {3.729790726049513*^9, 3.7297908347358427`*^9}, {
   3.729790886318983*^9, 3.7297908985495443`*^9}, {3.729790931251046*^9, 
   3.72979112317486*^9}, {3.72979116931327*^9, 3.729791269353731*^9}, {
   3.729791359892681*^9, 3.729791406067814*^9}, {3.7297914485241547`*^9, 
   3.72979144921026*^9}, {3.729791484698999*^9, 3.729791499044384*^9}, {
   3.729791566561154*^9, 3.729791584345121*^9}, {3.7297916430977707`*^9, 
   3.7297917327178802`*^9}, {3.729791770348117*^9, 3.729791837674281*^9}, {
   3.729895980928556*^9, 
   3.729895981310779*^9}},ExpressionUUID->"b5552447-0736-4862-b0e5-\
cec4e106c450"],

Cell[BoxData[
 DynamicModuleBox[{$CellContext`\[Alpha]\[Beta]Bishop$$ = True}, 
  TagBox[
   StyleBox[
    DynamicModuleBox[{$CellContext`kalQ$$ = 
     True, $CellContext`log\[Sigma]\[Zeta]$$ = -1.5, $CellContext`log\[Sigma]\
\[Xi]$$ = 0.5, $CellContext`mapQ$$ = True, $CellContext`mleQ$$ = 
     False, $CellContext`rlsQ$$ = True, $CellContext`\[CapitalMu]$$ = 4, 
     Typeset`show$$ = True, Typeset`bookmarkList$$ = {}, 
     Typeset`bookmarkMode$$ = "Menu", Typeset`animator$$, Typeset`animvar$$ = 
     1, Typeset`name$$ = "\"untitled\"", Typeset`specs$$ = {{{
        Hold[$CellContext`kalQ$$], True, "        KAL"}, {True, False}}, {{
        Hold[$CellContext`rlsQ$$], True, "        RLS"}, {True, False}}, {{
        Hold[$CellContext`mleQ$$], False, "        MLE"}, {True, False}}, {{
        Hold[$CellContext`mapQ$$], True, "        MAP"}, {True, False}}, {{
        Hold[$CellContext`\[CapitalMu]$$], 4, "order \[CapitalMu]"}, 0, 16, 
       1}, {{
        Hold[$CellContext`log\[Sigma]\[Xi]$$], 0.5, 
        "log \[Sigma]\[Xi] (KAL)"}, -3, 5}, {{
        Hold[$CellContext`log\[Sigma]\[Zeta]$$], -1.5, 
        "log \[Sigma]\[Zeta] (KAL)"}, -7, 3}, {
       Hold[
        Column[{
          SetterBar[
           Dynamic[$CellContext`\[Alpha]\[Beta]Bishop$$], {
           True -> "\[Alpha] = \!\(\*FractionBox[\(1\), SubsuperscriptBox[\(\
\[Sigma]\), \(\[Xi]\), \(2\)]]\), \[Beta] = \!\(\*FractionBox[\(1\), \
SubsuperscriptBox[\(\[Sigma]\), \(\[Zeta]\), \(2\)]]\)", False -> 
            "\[Alpha] = \!\(\*SubsuperscriptBox[\(\[Sigma]\), \(\[Zeta]\), \
\(2\)]\), \[Beta] = \!\(\*SubsuperscriptBox[\(\[Sigma]\), \(\[Xi]\), \
\(2\)]\)"}], 
          Row[{
            Button[
            "RESET", ($CellContext`\[CapitalMu]$$ = 
              4; $CellContext`log\[Sigma]\[Xi]$$ = 
              0.5; $CellContext`log\[Sigma]\[Zeta]$$ = -1.5)& ], 
            Manipulate`Place[1], 
            Manipulate`Place[2], 
            Manipulate`Place[3], 
            Manipulate`Place[4]}, Frame -> All], 
          Manipulate`Place[5], 
          Manipulate`Place[6], 
          Manipulate`Place[7]}]], Manipulate`Dump`ThisIsNotAControl}}, 
     Typeset`size$$ = {450., {146., 152.}}, Typeset`update$$ = 0, 
     Typeset`initDone$$, Typeset`skipInitDone$$ = 
     True, $CellContext`kalQ$3930$$ = False, $CellContext`rlsQ$3931$$ = 
     False, $CellContext`mleQ$3932$$ = False, $CellContext`mapQ$3933$$ = 
     False, $CellContext`\[CapitalMu]$3934$$ = 
     0, $CellContext`log\[Sigma]\[Xi]$3935$$ = 
     0, $CellContext`log\[Sigma]\[Zeta]$3936$$ = 0}, 
     DynamicBox[Manipulate`ManipulateBoxes[
      2, StandardForm, 
       "Variables" :> {$CellContext`kalQ$$ = 
         True, $CellContext`log\[Sigma]\[Zeta]$$ = -1.5, $CellContext`log\
\[Sigma]\[Xi]$$ = 0.5, $CellContext`mapQ$$ = True, $CellContext`mleQ$$ = 
         False, $CellContext`rlsQ$$ = True, $CellContext`\[CapitalMu]$$ = 4}, 
       "ControllerVariables" :> {
         Hold[$CellContext`kalQ$$, $CellContext`kalQ$3930$$, False], 
         Hold[$CellContext`rlsQ$$, $CellContext`rlsQ$3931$$, False], 
         Hold[$CellContext`mleQ$$, $CellContext`mleQ$3932$$, False], 
         Hold[$CellContext`mapQ$$, $CellContext`mapQ$3933$$, False], 
         Hold[$CellContext`\[CapitalMu]$$, $CellContext`\[CapitalMu]$3934$$, 
          0], 
         Hold[$CellContext`log\[Sigma]\[Xi]$$, \
$CellContext`log\[Sigma]\[Xi]$3935$$, 0], 
         Hold[$CellContext`log\[Sigma]\[Zeta]$$, $CellContext`log\[Sigma]\
\[Zeta]$3936$$, 0]}, 
       "OtherVariables" :> {
        Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
         Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
         Typeset`specs$$, Typeset`size$$, Typeset`update$$, 
         Typeset`initDone$$, Typeset`skipInitDone$$}, "Body" :> 
       Module[{$CellContext`x$}, 
         With[{$CellContext`terms$ = \
$CellContext`symbolicPowers[$CellContext`x$, $CellContext`\[CapitalMu]$$], \
$CellContext`cs$ = Map[
             $CellContext`\[Phi][$CellContext`\[CapitalMu]$$], 
             Map[List, 
              Part[$CellContext`bts, 1]]], $CellContext`ts$ = 
           Part[$CellContext`bts, 2], $CellContext`\[Sigma]\[Zeta]2$ = 
           10.^(2 $CellContext`log\[Sigma]\[Zeta]$$), $CellContext`\[Sigma]\
\[Xi]2$ = 10.^(2 $CellContext`log\[Sigma]\[Xi]$$)}, 
          
          With[{$CellContext`normal$ = $CellContext`mleFit[$CellContext`\
\[CapitalMu]$$, $CellContext`bts], $CellContext`kalman$ = \
$CellContext`kalFit[$CellContext`\[Sigma]\[Zeta]2$, \
$CellContext`\[Sigma]\[Xi]2$][$CellContext`\[CapitalMu]$$, $CellContext`bts], \
$CellContext`rrls$ = Quiet[
              $CellContext`rrlsFit[$CellContext`\[Sigma]\[Zeta]2$, \
$CellContext`\[Sigma]\[Xi]2$][$CellContext`\[CapitalMu]$$, \
$CellContext`bts]]}, 
           
           With[{$CellContext`\[Alpha]$ = 
             If[$CellContext`\[Alpha]\[Beta]Bishop$$, 
               1/$CellContext`\[Sigma]\[Xi]2$, \
$CellContext`\[Sigma]\[Zeta]2$], $CellContext`\[Beta]$ = 
             If[$CellContext`\[Alpha]\[Beta]Bishop$$, 
               1/$CellContext`\[Sigma]\[Zeta]2$, \
$CellContext`\[Sigma]\[Xi]2$]}, 
            
            With[{$CellContext`mleFn$ = 
              Dot[$CellContext`terms$, $CellContext`normal$], \
$CellContext`kalFn$ = Dot[{$CellContext`terms$}, 
                Part[$CellContext`kalman$, 1]], $CellContext`mapFn$ = Quiet[
                $CellContext`mapMean[$CellContext`\[Alpha]$, $CellContext`\
\[Beta]$, $CellContext`x$, $CellContext`cs$, $CellContext`ts$, $CellContext`\
\[CapitalMu]$$]], $CellContext`rlsFn$ = Dot[{$CellContext`terms$}, 
                Part[$CellContext`rrls$, 1]]}, 
             With[{$CellContext`lp$ = ListPlot[
                 Transpose[$CellContext`bts], PlotMarkers -> {
                   Graphics[{Blue, 
                    Circle[{0, 0}, 1]}], 0.05}]}, 
              Module[{$CellContext`showlist$ = {$CellContext`lp$, 
                  Plot[
                   Sin[2. Pi $CellContext`x$], {$CellContext`x$, 0., 1.}, 
                   PlotStyle -> {Thick, Green}]}}, If[$CellContext`mleQ$$, 
                 AppendTo[$CellContext`showlist$, 
                  
                  Plot[$CellContext`mleFn$, {$CellContext`x$, 0, 1}, 
                   PlotStyle -> {Orange}]]]; If[$CellContext`rlsQ$$, 
                 AppendTo[$CellContext`showlist$, 
                  
                  Plot[$CellContext`rlsFn$, {$CellContext`x$, 0, 1}, 
                   PlotStyle -> {Purple}]]]; If[$CellContext`kalQ$$, 
                 AppendTo[$CellContext`showlist$, 
                  
                  Plot[$CellContext`kalFn$, {$CellContext`x$, 0, 1}, 
                   PlotStyle -> {Cyan}]]]; If[$CellContext`mapQ$$, 
                 AppendTo[$CellContext`showlist$, 
                  
                  Plot[$CellContext`mapFn$, {$CellContext`x$, 0, 1}, 
                   PlotStyle -> {Magenta}]]]; Quiet[
                 
                 Show[$CellContext`showlist$, Frame -> True, ImageSize -> 
                  Medium, FrameLabel -> {{"\[Zeta]", ""}, {"\[Xi]", 
                    
                    Grid[{{"\[Alpha]: ", $CellContext`\[Alpha]$, 
                    "\[Beta]:", $CellContext`\[Beta]$}}]}}]]]]]]]]], 
       "Specifications" :> {{{$CellContext`kalQ$$, True, "        KAL"}, {
          True, False}, ControlPlacement -> 
          1}, {{$CellContext`rlsQ$$, True, "        RLS"}, {True, False}, 
          ControlPlacement -> 
          2}, {{$CellContext`mleQ$$, False, "        MLE"}, {True, False}, 
          ControlPlacement -> 
          3}, {{$CellContext`mapQ$$, True, "        MAP"}, {True, False}, 
          ControlPlacement -> 
          4}, {{$CellContext`\[CapitalMu]$$, 4, "order \[CapitalMu]"}, 0, 16, 
          1, Appearance -> {"Labeled"}, ControlPlacement -> 
          5}, {{$CellContext`log\[Sigma]\[Xi]$$, 0.5, 
           "log \[Sigma]\[Xi] (KAL)"}, -3, 5, Appearance -> "Labeled", 
          ControlPlacement -> 
          6}, {{$CellContext`log\[Sigma]\[Zeta]$$, -1.5, 
           "log \[Sigma]\[Zeta] (KAL)"}, -7, 3, Appearance -> "Labeled", 
          ControlPlacement -> 7}, 
         Column[{
           SetterBar[
            Dynamic[$CellContext`\[Alpha]\[Beta]Bishop$$], {
            True -> "\[Alpha] = \!\(\*FractionBox[\(1\), SubsuperscriptBox[\(\
\[Sigma]\), \(\[Xi]\), \(2\)]]\), \[Beta] = \!\(\*FractionBox[\(1\), \
SubsuperscriptBox[\(\[Sigma]\), \(\[Zeta]\), \(2\)]]\)", False -> 
             "\[Alpha] = \!\(\*SubsuperscriptBox[\(\[Sigma]\), \(\[Zeta]\), \
\(2\)]\), \[Beta] = \!\(\*SubsuperscriptBox[\(\[Sigma]\), \(\[Xi]\), \
\(2\)]\)"}], 
           Row[{
             Button[
             "RESET", ($CellContext`\[CapitalMu]$$ = 
               4; $CellContext`log\[Sigma]\[Xi]$$ = 
               0.5; $CellContext`log\[Sigma]\[Zeta]$$ = -1.5)& ], 
             Manipulate`Place[1], 
             Manipulate`Place[2], 
             Manipulate`Place[3], 
             Manipulate`Place[4]}, Frame -> All], 
           Manipulate`Place[5], 
           Manipulate`Place[6], 
           Manipulate`Place[7]}]}, "Options" :> {}, "DefaultOptions" :> {}],
      ImageSizeCache->{505., {275., 282.}},
      SingleEvaluation->True],
     Deinitialization:>None,
     DynamicModuleValues:>{},
     SynchronousInitialization->True,
     UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
     UnsavedVariables:>{Typeset`initDone$$},
     UntrackedVariables:>{Typeset`size$$}], "Manipulate",
    Deployed->True,
    StripOnInput->False],
   Manipulate`InterpretManipulate[1]],
  DynamicModuleValues:>{}]], "Output",
 CellChangeTimes->{
  3.729784381207548*^9, 3.7297844163676357`*^9, {3.729784455537157*^9, 
   3.7297844797500753`*^9}, 3.72978454961663*^9, {3.729784579881394*^9, 
   3.729784637108739*^9}, {3.729784681722384*^9, 3.729784717710224*^9}, 
   3.729784779431076*^9, 3.729784841514982*^9, 3.729784874445601*^9, 
   3.7297849071649437`*^9, 3.729784987534523*^9, {3.729790344993404*^9, 
   3.729790401881814*^9}, 3.729790471804407*^9, 3.729790516129326*^9, {
   3.729790611352343*^9, 3.729790631024955*^9}, 3.7297908377804728`*^9, 
   3.729791052324683*^9, 3.729791125345771*^9, 3.729791176940489*^9, {
   3.729791226113031*^9, 3.7297912700673437`*^9}, {3.729791366986239*^9, 
   3.7297914073716087`*^9}, 3.729791450410841*^9, {3.7297914878437138`*^9, 
   3.729791499782393*^9}, {3.729791573356472*^9, 3.7297915848841753`*^9}, {
   3.729791700338099*^9, 3.729791721639224*^9}, 3.729791807132395*^9, 
   3.729894701378387*^9, {3.729895982956667*^9, 3.729896007208116*^9}, 
   3.729896154153077*^9},ExpressionUUID->"aa8e5bb6-b1af-4701-b70e-\
6c67088c0125"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Covariance of the Estimate", "Subsection",
 CellChangeTimes->{{3.729182953019375*^9, 
  3.7291829585476*^9}},ExpressionUUID->"f9d182b7-2ea0-4aa4-858d-e1d52a7855f1"],

Cell[TextData[{
 "Consider Bishop' s equation 1.71 ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     SuperscriptBox["s", "2"], "(", "x", ")"}], "=", 
    RowBox[{
     SuperscriptBox["\[Beta]", 
      RowBox[{"\[ThinSpace]", 
       RowBox[{"-", "1"}]}]], "+", 
     RowBox[{
      RowBox[{
       RowBox[{"\[Phi]", "\[ThinSpace]", "(", "x", ")"}], "\[Transpose]"}], 
      "\[CenterDot]", "S", "\[CenterDot]", 
      RowBox[{"\[Phi]", "\[ThinSpace]", "(", "x", ")"}]}]}]}], 
   TraditionalForm]],ExpressionUUID->"6dfcd263-a97d-4bbd-8240-18fb850b2a01"],
 ", which does not depend on the output data ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["t", "n"], TraditionalForm]],ExpressionUUID->
  "2c5fff2e-1c1d-406e-901d-41521c38df61"],
 ", just as with KAL and RLS\.7f."
}], "Text",
 CellChangeTimes->{{3.727994165301249*^9, 3.7279941851829967`*^9}, {
  3.72808526244471*^9, 3.728085323623013*^9}, {3.728253500899654*^9, 
  3.728253506076968*^9}, {3.729175093713661*^9, 3.7291750988463297`*^9}, {
  3.729189840044029*^9, 3.7291898706889067`*^9}, {3.7291903288986673`*^9, 
  3.729190329452014*^9}, {3.7297115752429132`*^9, 
  3.729711651456718*^9}},ExpressionUUID->"a68e9f71-53f7-405c-9f44-\
8b8c664da203"],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ClearAll", "[", "mapsSquared", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"mapsSquared", "[", 
    RowBox[{
    "\[Alpha]_", ",", "\[Beta]_", ",", "x_", ",", "cs_", ",", 
     "\[CapitalMu]_"}], "]"}], ":=", "\[IndentingNewLine]", 
   RowBox[{"With", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"a", "=", 
       RowBox[{
        RowBox[{"\[Phi]", "[", "\[CapitalMu]", "]"}], "[", "x", "]"}]}], 
      "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{
      SuperscriptBox["\[Beta]", 
       RowBox[{"-", "1"}]], "+", 
      RowBox[{
       RowBox[{"{", "a", "}"}], ".", 
       RowBox[{"LinearSolve", "[", 
        RowBox[{
         RowBox[{"sInv", "[", 
          RowBox[{
          "\[Alpha]", ",", "\[Beta]", ",", "cs", ",", "\[CapitalMu]"}], "]"}],
          ",", 
         RowBox[{"List", "/@", "a"}]}], "]"}]}]}]}], "]"}]}], ";"}]}], "Input",\

 CellChangeTimes->{{3.727994197366062*^9, 3.7279942096588373`*^9}, {
   3.727994247046831*^9, 3.7279942495547533`*^9}, {3.7279943024871273`*^9, 
   3.7279946538407373`*^9}, {3.7280359193758917`*^9, 3.728035920837536*^9}, 
   3.729175085479534*^9, 3.7291756488901587`*^9, {3.729175930984292*^9, 
   3.7291759413745337`*^9}, {3.72918296865281*^9, 3.72918296932966*^9}, {
   3.729195696029108*^9, 
   3.729195744219352*^9}},ExpressionUUID->"a5b4f1d7-f50f-4606-8d82-\
719fa8c626fa"],

Cell[TextData[{
 "Bishop kindly supplies the sigma-bars for his mean. He cites ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Alpha]", "=", "0.005"}], TraditionalForm]],ExpressionUUID->
  "716c6835-a0ca-4e21-a1e5-f1fabb29a20e"],
 " and ",
 Cell[BoxData[
  FormBox[
   RowBox[{"\[Beta]", "=", "11.1"}], TraditionalForm]],ExpressionUUID->
  "34eda4a5-047a-4ac4-89f4-ad3002dd4e23"],
 ", which correspond to ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[Sigma]", "\[Zeta]"], "=", 
    FormBox["0.07071",
     TraditionalForm]}], TraditionalForm]],ExpressionUUID->
  "84d7f102-4b43-4dff-aa17-d8119992c171"],
 " and ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    SubscriptBox["\[Sigma]", "\[Xi]"], "=", 
    FormBox["3.333",
     TraditionalForm]}], TraditionalForm]],ExpressionUUID->
  "0925b158-a2eb-4d33-8d5d-20d2fb6b998c"],
 ", and ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     SubscriptBox["log", "10"], 
     SubscriptBox["\[Sigma]", "\[Zeta]"]}], "=", 
    FormBox[
     RowBox[{"-", "1.1505149978319906`"}],
     TraditionalForm]}], TraditionalForm]],ExpressionUUID->
  "89a82430-c61c-45d2-8428-421f2038513e"],
 " and ",
 Cell[BoxData[
  FormBox[
   RowBox[{
    RowBox[{
     SubscriptBox["log", "10"], 
     SubscriptBox["\[Sigma]", "\[Xi]"]}], "=", 
    FormBox["0.5229",
     TraditionalForm]}], TraditionalForm]],ExpressionUUID->
  "6c4ddb46-0404-4254-a14b-31d303fbb18d"],
 ". These values reproduce Bishop\[CloseCurlyQuote]s figure 1.17 well.\n\n\
Kalman\[CloseCurlyQuote]s output covariance ",
 Cell[BoxData[
  FormBox["P", TraditionalForm]],ExpressionUUID->
  "a880d95f-b2f1-45ad-93d4-7b5e04e54930"],
 " and RLS\[CloseCurlyQuote]s output information ",
 Cell[BoxData[
  FormBox["\[CapitalPi]", TraditionalForm]],ExpressionUUID->
  "85e9a51d-5c4f-4bc8-9a7c-127e8310e19d"],
 " represent uncertainty in the estimated coefficients. These do not directly \
yield uncertainties in the predicted labels, i.e., polynomials evaluated at \
each input point. For those, we follow Bishop\[CloseCurlyQuote]s analysis and \
his equation 1.71."
}], "Text",
 CellChangeTimes->{{3.728047983582913*^9, 3.728048001419952*^9}, {
   3.728048031472519*^9, 3.728048102784032*^9}, 3.728048334620097*^9, {
   3.728048573076227*^9, 3.7280485742423983`*^9}, {3.7291832860169077`*^9, 
   3.729183286905438*^9}, {3.7291909187303047`*^9, 3.729190931736122*^9}, {
   3.729190966915935*^9, 3.72919115612007*^9}, {3.7291913182402887`*^9, 
   3.729191334853733*^9}, {3.729194967822537*^9, 3.7291949964757357`*^9}, {
   3.729195092532947*^9, 3.729195228731798*^9}, {3.7291952960364323`*^9, 
   3.729195346443692*^9}, {3.729195461293686*^9, 3.729195465395809*^9}, {
   3.729195529898984*^9, 3.7291955825492153`*^9}, 3.729196046713995*^9, {
   3.729196202829361*^9, 3.729196223138455*^9}, {3.7291963897537813`*^9, 
   3.7291963938344088`*^9}, {3.729711666635454*^9, 
   3.729711717573139*^9}},ExpressionUUID->"0b5b81b7-be5c-4486-a0ed-\
f498beaa94fa"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Manipulate", "[", 
  RowBox[{
   RowBox[{"Module", "[", 
    RowBox[{
     RowBox[{"{", "x", "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"terms", "=", 
          RowBox[{"symbolicPowers", "[", 
           RowBox[{"x", ",", "\[CapitalMu]"}], "]"}]}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"cs", "=", 
          RowBox[{
           RowBox[{"\[Phi]", "[", "\[CapitalMu]", "]"}], "/@", 
           RowBox[{"List", "/@", 
            RowBox[{
            "bts", "\[LeftDoubleBracket]", "1", 
             "\[RightDoubleBracket]"}]}]}]}], ",", 
         RowBox[{"ts", "=", 
          RowBox[{
          "bts", "\[LeftDoubleBracket]", "2", "\[RightDoubleBracket]"}]}]}], 
        "}"}], ",", "\[IndentingNewLine]", 
       RowBox[{"With", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"normal", "=", 
            RowBox[{"mleFit", "[", 
             RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"kalman", "=", 
            RowBox[{
             RowBox[{"kalFit", "[", 
              RowBox[{
               SuperscriptBox["10", 
                RowBox[{"2", "log\[Sigma]\[Zeta]"}]], ",", 
               SuperscriptBox["10", 
                RowBox[{"2", "log\[Sigma]\[Xi]"}]]}], "]"}], "[", 
             RowBox[{"\[CapitalMu]", ",", "bts"}], "]"}]}]}], "}"}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{"With", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{"mleFn", "=", 
              RowBox[{"terms", ".", "normal"}]}], ",", "\[IndentingNewLine]", 
             
             RowBox[{"kalFn", "=", 
              RowBox[{
               RowBox[{"{", "terms", "}"}], ".", 
               RowBox[{
               "kalman", "\[LeftDoubleBracket]", "1", 
                "\[RightDoubleBracket]"}]}]}], ",", "\[IndentingNewLine]", 
             RowBox[{"bs2", "=", 
              RowBox[{"mapsSquared", "[", 
               RowBox[{
                SuperscriptBox["10", 
                 RowBox[{"2", "log\[Sigma]\[Zeta]"}]], ",", 
                SuperscriptBox["10", 
                 RowBox[{"2", "log\[Sigma]\[Xi]"}]], ",", "x", ",", "cs", ",",
                 "\[CapitalMu]"}], 
               StyleBox["]",
                Background->RGBColor[1, 1, 0]]}]}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{"mapFn", "=", 
              RowBox[{"Quiet", "@", 
               RowBox[{"mapMean", "[", 
                RowBox[{
                 SuperscriptBox["10", 
                  RowBox[{"2", "log\[Sigma]\[Zeta]"}]], ",", 
                 SuperscriptBox["10", 
                  RowBox[{"2", "log\[Sigma]\[Xi]"}]], ",", "x", ",", "cs", 
                 ",", "ts", ",", "\[CapitalMu]"}], "]"}]}]}]}], "}"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"With", "[", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"lp", "=", 
               RowBox[{"ListPlot", "[", 
                RowBox[{
                 RowBox[{"bts", "\[Transpose]"}], ",", "\[IndentingNewLine]", 
                 
                 RowBox[{"PlotMarkers", "\[Rule]", 
                  RowBox[{"{", 
                   RowBox[{
                    RowBox[{"Graphics", "@", 
                    RowBox[{"{", 
                    RowBox[{"Blue", ",", 
                    RowBox[{"Circle", "[", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"0", ",", "0"}], "}"}], ",", "1"}], "]"}]}], 
                    "}"}]}], ",", ".05"}], "}"}]}]}], "]"}]}], "}"}], ",", 
             "\[IndentingNewLine]", 
             RowBox[{"Module", "[", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"showlist", "=", 
                 RowBox[{"{", 
                  RowBox[{"lp", ",", 
                   RowBox[{"Plot", "[", 
                    RowBox[{
                    RowBox[{"Sin", "[", 
                    RowBox[{"2.", "\[Pi]", " ", "x"}], "]"}], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0.", ",", "1."}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"Thick", ",", "Green"}], "}"}]}]}], "]"}]}], 
                  "}"}]}], "}"}], ",", "\[IndentingNewLine]", 
               RowBox[{
                RowBox[{"If", "[", 
                 RowBox[{"mleQ", ",", 
                  RowBox[{"AppendTo", "[", 
                   RowBox[{"showlist", ",", 
                    RowBox[{"Plot", "[", 
                    RowBox[{"mleFn", ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", "Orange", "}"}]}]}], "]"}]}], "]"}]}], "]"}],
                 ";", "\[IndentingNewLine]", 
                RowBox[{"If", "[", 
                 RowBox[{"kalQ", ",", 
                  RowBox[{"AppendTo", "[", 
                   RowBox[{"showlist", ",", "\[IndentingNewLine]", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"kalFn", ",", 
                    RowBox[{"kalFn", "+", 
                    SqrtBox["bs2"]}], ",", 
                    RowBox[{"kalFn", "-", 
                    SqrtBox["bs2"]}]}], "}"}], ",", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    "\[IndentingNewLine]", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"Cyan", ",", 
                    RowBox[{"{", 
                    RowBox[{"Thin", ",", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"Opacity", "[", "0", "]"}], ",", "Cyan"}], 
                    "}"}]}], "}"}], ",", 
                    RowBox[{"{", 
                    RowBox[{"Thin", ",", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"Opacity", "[", "0", "]"}], ",", "Cyan"}], 
                    "}"}]}], "}"}]}], "}"}]}], ",", 
                    RowBox[{"Filling", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"1", "\[Rule]", 
                    RowBox[{"{", "2", "}"}]}], ",", 
                    RowBox[{"1", "\[Rule]", 
                    RowBox[{"{", "3", "}"}]}]}], "}"}]}]}], "]"}]}], "]"}]}], 
                 "]"}], ";", "\[IndentingNewLine]", 
                RowBox[{"If", "[", 
                 RowBox[{"mapQ", ",", 
                  RowBox[{"AppendTo", "[", 
                   RowBox[{"showlist", ",", "\[IndentingNewLine]", 
                    RowBox[{"Plot", "[", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"mapFn", ",", 
                    RowBox[{"mapFn", "+", 
                    SqrtBox["bs2"]}], ",", 
                    RowBox[{"mapFn", "-", 
                    SqrtBox["bs2"]}]}], "}"}], ",", "\[IndentingNewLine]", 
                    RowBox[{"{", 
                    RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                    "\[IndentingNewLine]", 
                    RowBox[{"PlotStyle", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"Magenta", ",", 
                    RowBox[{"{", 
                    RowBox[{"Thin", ",", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"Opacity", "[", "0", "]"}], ",", "Magenta"}], 
                    "}"}]}], "}"}], ",", 
                    RowBox[{"{", 
                    RowBox[{"Thin", ",", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"Opacity", "[", "0", "]"}], ",", "Magenta"}], 
                    "}"}]}], "}"}]}], "}"}]}], ",", "\[IndentingNewLine]", 
                    RowBox[{"Filling", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"1", "\[Rule]", 
                    RowBox[{"{", "2", "}"}]}], ",", 
                    RowBox[{"1", "\[Rule]", 
                    RowBox[{"{", "3", "}"}]}]}], "}"}]}]}], "]"}]}], "]"}]}], 
                 "]"}], ";", "\[IndentingNewLine]", 
                RowBox[{"Quiet", "@", 
                 RowBox[{"Show", "[", 
                  RowBox[{"showlist", ",", 
                   RowBox[{"Frame", "\[Rule]", "True"}], ",", 
                   RowBox[{"FrameLabel", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{"\"\<x\>\"", ",", "\"\<t\>\""}], "}"}]}]}], 
                  "]"}]}]}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}], 
    "]"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Grid", "[", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"Grid", "[", 
        RowBox[{"{", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"Button", "[", 
            RowBox[{"\"\<RESET\>\"", ",", 
             RowBox[{
              RowBox[{"(", 
               RowBox[{
                RowBox[{"\[CapitalMu]", "=", "9"}], ";", 
                RowBox[{"log\[Sigma]\[Xi]", "=", 
                 RowBox[{"Log10", "[", 
                  SqrtBox[
                   RowBox[{"1", "/", "0.09"}]], "]"}]}], ";", 
                RowBox[{"log\[Sigma]\[Zeta]", "=", 
                 RowBox[{"Log10", "[", 
                  SqrtBox["0.005"], "]"}]}]}], ")"}], "&"}]}], "]"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"Control", "[", 
            RowBox[{"{", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"kalQ", ",", "True", ",", "\"\<KAL\>\""}], "}"}], ",", 
              
              RowBox[{"{", 
               RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"Control", "[", 
            RowBox[{"{", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"mleQ", ",", "False", ",", "\"\<MLE\>\""}], "}"}], ",", 
              RowBox[{"{", 
               RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}], ",", 
           "\[IndentingNewLine]", 
           RowBox[{"Control", "[", 
            RowBox[{"{", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"mapQ", ",", "True", ",", "\"\<MAP\>\""}], "}"}], ",", 
              
              RowBox[{"{", 
               RowBox[{"True", ",", "False"}], "}"}]}], "}"}], "]"}]}], "}"}],
          "}"}], "]"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"Control", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
           "\[CapitalMu]", ",", "9", ",", "\"\<order \[CapitalMu]\>\""}], 
           "}"}], ",", "0", ",", "16", ",", "1", ",", 
          RowBox[{"Appearance", "\[Rule]", 
           RowBox[{"{", "\"\<Labeled\>\"", "}"}]}]}], "}"}], "]"}], "}"}], 
      ",", 
      RowBox[{"{", 
       RowBox[{"Control", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"log\[Sigma]\[Xi]", ",", 
            RowBox[{"Log10", "[", 
             SqrtBox[
              RowBox[{"1", "/", "0.09"}]], "]"}], ",", 
            "\"\<log \[Sigma]\[Xi] (KAL)\>\""}], "}"}], ",", 
          RowBox[{"-", "3"}], ",", " ", "5", ",", 
          RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], 
        "]"}], "}"}], ",", "\[IndentingNewLine]", 
      RowBox[{"{", 
       RowBox[{"Control", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"log\[Sigma]\[Zeta]", ",", 
            RowBox[{"Log10", "[", 
             SqrtBox["0.005"], "]"}], ",", 
            "\"\<log \[Sigma]\[Zeta] (KAL)\>\""}], "}"}], ",", 
          RowBox[{"-", "5"}], ",", "3", ",", 
          RowBox[{"Appearance", "\[Rule]", "\"\<Labeled\>\""}]}], "}"}], 
        "]"}], "}"}]}], "}"}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.727884681931381*^9, 3.7278848244947367`*^9}, 
   3.727884861217602*^9, {3.727884975910451*^9, 3.7278849940673532`*^9}, {
   3.727885103521431*^9, 3.727885154698123*^9}, {3.72788520225443*^9, 
   3.727885279820177*^9}, {3.727885496115718*^9, 3.727885517688189*^9}, {
   3.72788559395383*^9, 3.727885598972475*^9}, {3.7278856296542664`*^9, 
   3.727885630876935*^9}, {3.727885695972756*^9, 3.727885696864628*^9}, {
   3.727886633660364*^9, 3.72788671287046*^9}, {3.727886975364171*^9, 
   3.727886975439041*^9}, {3.727903476653379*^9, 3.7279034819231358`*^9}, {
   3.727903531862627*^9, 3.727903539245574*^9}, 3.727913149489944*^9, {
   3.727915429732944*^9, 3.7279154437948627`*^9}, {3.727915750998211*^9, 
   3.7279158447033873`*^9}, {3.7279213832695303`*^9, 3.72792149154887*^9}, {
   3.727921523149373*^9, 3.72792161270367*^9}, {3.72792165300301*^9, 
   3.727921654632832*^9}, {3.727921753282296*^9, 3.727921753360197*^9}, {
   3.727924008558401*^9, 3.727924045018003*^9}, {3.727924293814445*^9, 
   3.727924370827516*^9}, 3.727965590613636*^9, {3.7279686551525917`*^9, 
   3.727968670349081*^9}, {3.7279689406605043`*^9, 3.727969019631563*^9}, {
   3.727970883056108*^9, 3.727970945128386*^9}, {3.727971005813472*^9, 
   3.727971023734253*^9}, {3.727990640753121*^9, 3.727990674786282*^9}, {
   3.727990711779483*^9, 3.727990808626033*^9}, {3.727991307012423*^9, 
   3.727991307022031*^9}, {3.7279932412769613`*^9, 3.7279932949280367`*^9}, {
   3.7279933910397243`*^9, 3.727993398358789*^9}, {3.727993778490755*^9, 
   3.72799379332897*^9}, {3.727993826040863*^9, 3.7279938751552763`*^9}, {
   3.727993956673335*^9, 3.727993958184173*^9}, 3.727994128012043*^9, {
   3.7280354067714148`*^9, 3.7280354258611927`*^9}, {3.728035634299762*^9, 
   3.728035732029833*^9}, {3.72803585641748*^9, 3.728035906176405*^9}, {
   3.728038924314391*^9, 3.728039041653799*^9}, {3.728039077026232*^9, 
   3.72803913265169*^9}, {3.728039194847865*^9, 3.728039320044661*^9}, {
   3.728044256958378*^9, 3.728044343151896*^9}, {3.728044393583234*^9, 
   3.728044466540698*^9}, 3.7280447095836163`*^9, {3.728044856722988*^9, 
   3.728044959527645*^9}, {3.728044995179022*^9, 3.728044998104682*^9}, {
   3.728045028753289*^9, 3.728045063548128*^9}, {3.728045464570526*^9, 
   3.728045476328084*^9}, {3.728045812340419*^9, 3.728045836978776*^9}, {
   3.7280461335391397`*^9, 3.728046355530389*^9}, {3.728046392282709*^9, 
   3.728046397281275*^9}, {3.728046429888109*^9, 3.728046434285967*^9}, {
   3.728046509047914*^9, 3.728046577986915*^9}, {3.728048625582951*^9, 
   3.728048658147644*^9}, {3.728048704639155*^9, 3.7280487209829884`*^9}, {
   3.728048763333255*^9, 3.728048783520523*^9}, 3.728048849900649*^9, {
   3.728048881350296*^9, 3.7280488887365723`*^9}, {3.7280489358794527`*^9, 
   3.728048947834031*^9}, {3.7280492952517767`*^9, 3.728049427179392*^9}, {
   3.728049506853256*^9, 3.7280496162697783`*^9}, {3.728050015065921*^9, 
   3.7280500376507397`*^9}, {3.7280500733077374`*^9, 
   3.7280501005796213`*^9}, {3.728089881496944*^9, 3.728089882038129*^9}, {
   3.728090725835964*^9, 3.728090725845487*^9}, {3.728169349750301*^9, 
   3.728169349773612*^9}, {3.728169400997793*^9, 3.728169417906619*^9}, {
   3.728169511798567*^9, 3.728169523731205*^9}, {3.7281696125541363`*^9, 
   3.7281696306368437`*^9}, 3.728226727530678*^9, {3.728226810131266*^9, 
   3.728226816018466*^9}, {3.728226857072884*^9, 3.728226861119492*^9}, 
   3.728245946305786*^9, {3.7282487072286263`*^9, 3.728248709889584*^9}, {
   3.728251170478485*^9, 3.728251170709284*^9}, {3.7282526609079533`*^9, 
   3.728252718943617*^9}, 3.728252776351699*^9, {3.728252825506783*^9, 
   3.7282528275522842`*^9}, {3.7282528645183697`*^9, 3.728252865147182*^9}, 
   3.7282539826691*^9, {3.7291194284711437`*^9, 3.729119493281761*^9}, {
   3.7291195510227203`*^9, 3.729119680314639*^9}, {3.729119849724024*^9, 
   3.7291198585722113`*^9}, {3.7291717881457*^9, 3.729171818317573*^9}, {
   3.729171854440769*^9, 3.729171871385407*^9}, {3.72917192869256*^9, 
   3.7291720371346607`*^9}, {3.729173126976542*^9, 3.729173139435835*^9}, {
   3.729173200255974*^9, 3.729173275110746*^9}, {3.7291733458987417`*^9, 
   3.729173346264063*^9}, {3.729173389656439*^9, 3.729173389676496*^9}, {
   3.729173453362727*^9, 3.729173453374463*^9}, {3.72917500863538*^9, 
   3.729175053102626*^9}, {3.729175506297736*^9, 3.72917551618956*^9}, {
   3.729175643623238*^9, 3.729175648090048*^9}, {3.729176146733549*^9, 
   3.729176146742311*^9}, {3.729178985302376*^9, 3.729179018757811*^9}, {
   3.729179428316293*^9, 3.729179429546385*^9}, {3.7291833107508097`*^9, 
   3.729183351716688*^9}, {3.729183394435251*^9, 3.729183394441711*^9}, {
   3.729190091733934*^9, 3.729190094653805*^9}, {3.7291901727265663`*^9, 
   3.729190190738206*^9}, 3.7291903189647007`*^9, {3.729190363535774*^9, 
   3.729190420438587*^9}, {3.729190855161989*^9, 3.7291908759621487`*^9}, {
   3.729191173998303*^9, 3.729191310565546*^9}, {3.729191815211359*^9, 
   3.729191966406259*^9}, {3.729192009289757*^9, 3.729192012183796*^9}, 
   3.729192076913485*^9, {3.7291921189255133`*^9, 3.72919222651994*^9}, {
   3.7291934084762163`*^9, 3.7291934717245827`*^9}, {3.729193512347974*^9, 
   3.729193699962986*^9}, {3.7291937883162937`*^9, 3.72919391294538*^9}, {
   3.729193943825762*^9, 3.7291939503531523`*^9}, {3.729194005235033*^9, 
   3.729194075561458*^9}, 3.729195508767318*^9, {3.729196245290443*^9, 
   3.7291962556403313`*^9}, {3.729196364803418*^9, 3.7291963689564*^9}, {
   3.729196403932249*^9, 3.729196414116873*^9}, 
   3.729551253178636*^9},ExpressionUUID->"47a4767a-c2e8-4fe7-9b95-\
1f656995693b"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`kalQ$$ = 
    True, $CellContext`log\[Sigma]\[Zeta]$$ = -1.1505149978319906`, \
$CellContext`log\[Sigma]\[Xi]$$ = 0.5228787452803376, $CellContext`mapQ$$ = 
    True, $CellContext`mleQ$$ = False, $CellContext`\[CapitalMu]$$ = 9, 
    Typeset`show$$ = True, Typeset`bookmarkList$$ = {}, 
    Typeset`bookmarkMode$$ = "Menu", Typeset`animator$$, Typeset`animvar$$ = 
    1, Typeset`name$$ = "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`kalQ$$], True, "KAL"}, {True, False}}, {{
       Hold[$CellContext`mleQ$$], False, "MLE"}, {True, False}}, {{
       Hold[$CellContext`mapQ$$], True, "MAP"}, {True, False}}, {{
       Hold[$CellContext`\[CapitalMu]$$], 9, "order \[CapitalMu]"}, 0, 16, 
      1}, {{
       Hold[$CellContext`log\[Sigma]\[Xi]$$], 0.5228787452803376, 
       "log \[Sigma]\[Xi] (KAL)"}, -3, 5}, {{
       Hold[$CellContext`log\[Sigma]\[Zeta]$$], -1.1505149978319906`, 
       "log \[Sigma]\[Zeta] (KAL)"}, -5, 3}, {
      Hold[
       Grid[{{
          Grid[{{
             Button[
             "RESET", ($CellContext`\[CapitalMu]$$ = 
               9; $CellContext`log\[Sigma]\[Xi]$$ = Log10[
                 Sqrt[1/0.09]]; $CellContext`log\[Sigma]\[Zeta]$$ = Log10[
                 Sqrt[0.005]])& ], 
             Manipulate`Place[1], 
             Manipulate`Place[2], 
             Manipulate`Place[3]}}]}, {
          Manipulate`Place[4]}, {
          Manipulate`Place[5]}, {
          Manipulate`Place[6]}}]], Manipulate`Dump`ThisIsNotAControl}}, 
    Typeset`size$$ = {450., {141., 147.}}, Typeset`update$$ = 0, 
    Typeset`initDone$$, Typeset`skipInitDone$$ = 
    True, $CellContext`kalQ$4209$$ = False, $CellContext`mleQ$4210$$ = 
    False, $CellContext`mapQ$4211$$ = 
    False, $CellContext`\[CapitalMu]$4212$$ = 
    0, $CellContext`log\[Sigma]\[Xi]$4213$$ = 
    0, $CellContext`log\[Sigma]\[Zeta]$4214$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     2, StandardForm, 
      "Variables" :> {$CellContext`kalQ$$ = 
        True, $CellContext`log\[Sigma]\[Zeta]$$ = -1.1505149978319906`, \
$CellContext`log\[Sigma]\[Xi]$$ = 0.5228787452803376, $CellContext`mapQ$$ = 
        True, $CellContext`mleQ$$ = False, $CellContext`\[CapitalMu]$$ = 9}, 
      "ControllerVariables" :> {
        Hold[$CellContext`kalQ$$, $CellContext`kalQ$4209$$, False], 
        Hold[$CellContext`mleQ$$, $CellContext`mleQ$4210$$, False], 
        Hold[$CellContext`mapQ$$, $CellContext`mapQ$4211$$, False], 
        Hold[$CellContext`\[CapitalMu]$$, $CellContext`\[CapitalMu]$4212$$, 
         0], 
        Hold[$CellContext`log\[Sigma]\[Xi]$$, \
$CellContext`log\[Sigma]\[Xi]$4213$$, 0], 
        Hold[$CellContext`log\[Sigma]\[Zeta]$$, $CellContext`log\[Sigma]\
\[Zeta]$4214$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Module[{$CellContext`x$}, 
        With[{$CellContext`terms$ = \
$CellContext`symbolicPowers[$CellContext`x$, $CellContext`\[CapitalMu]$$], \
$CellContext`cs$ = Map[
            $CellContext`\[Phi][$CellContext`\[CapitalMu]$$], 
            Map[List, 
             Part[$CellContext`bts, 1]]], $CellContext`ts$ = 
          Part[$CellContext`bts, 2]}, 
         With[{$CellContext`normal$ = $CellContext`mleFit[$CellContext`\
\[CapitalMu]$$, $CellContext`bts], $CellContext`kalman$ = $CellContext`kalFit[
            10^(2 $CellContext`log\[Sigma]\[Zeta]$$), 
             10^(2 $CellContext`log\[Sigma]\[Xi]$$)][$CellContext`\[CapitalMu]\
$$, $CellContext`bts]}, 
          
          With[{$CellContext`mleFn$ = 
            Dot[$CellContext`terms$, $CellContext`normal$], \
$CellContext`kalFn$ = Dot[{$CellContext`terms$}, 
              
              Part[$CellContext`kalman$, 
               1]], $CellContext`bs2$ = $CellContext`mapsSquared[
             10^(2 $CellContext`log\[Sigma]\[Zeta]$$), 
              10^(
               2 $CellContext`log\[Sigma]\[Xi]$$), $CellContext`x$, \
$CellContext`cs$, $CellContext`\[CapitalMu]$$], $CellContext`mapFn$ = Quiet[
              $CellContext`mapMean[
              10^(2 $CellContext`log\[Sigma]\[Zeta]$$), 
               10^(2 $CellContext`log\[Sigma]\[Xi]$$), $CellContext`x$, \
$CellContext`cs$, $CellContext`ts$, $CellContext`\[CapitalMu]$$]]}, 
           With[{$CellContext`lp$ = ListPlot[
               Transpose[$CellContext`bts], PlotMarkers -> {
                 Graphics[{Blue, 
                   Circle[{0, 0}, 1]}], 0.05}]}, 
            Module[{$CellContext`showlist$ = {$CellContext`lp$, 
                Plot[
                 Sin[2. Pi $CellContext`x$], {$CellContext`x$, 0., 1.}, 
                 PlotStyle -> {Thick, Green}]}}, If[$CellContext`mleQ$$, 
               AppendTo[$CellContext`showlist$, 
                
                Plot[$CellContext`mleFn$, {$CellContext`x$, 0, 1}, 
                 PlotStyle -> {Orange}]]]; If[$CellContext`kalQ$$, 
               AppendTo[$CellContext`showlist$, 
                
                Plot[{$CellContext`kalFn$, $CellContext`kalFn$ + 
                  Sqrt[$CellContext`bs2$], $CellContext`kalFn$ - 
                  Sqrt[$CellContext`bs2$]}, {$CellContext`x$, 0, 1}, 
                 PlotStyle -> {Cyan, {Thin, {
                    Opacity[0], Cyan}}, {Thin, {
                    Opacity[0], Cyan}}}, Filling -> {1 -> {2}, 1 -> {3}}]]]; 
             If[$CellContext`mapQ$$, 
               AppendTo[$CellContext`showlist$, 
                
                Plot[{$CellContext`mapFn$, $CellContext`mapFn$ + 
                  Sqrt[$CellContext`bs2$], $CellContext`mapFn$ - 
                  Sqrt[$CellContext`bs2$]}, {$CellContext`x$, 0, 1}, 
                 PlotStyle -> {Magenta, {Thin, {
                    Opacity[0], Magenta}}, {Thin, {
                    Opacity[0], Magenta}}}, 
                 Filling -> {1 -> {2}, 1 -> {3}}]]]; Quiet[
               
               Show[$CellContext`showlist$, Frame -> True, 
                FrameLabel -> {"x", "t"}]]]]]]]], 
      "Specifications" :> {{{$CellContext`kalQ$$, True, "KAL"}, {True, False},
          ControlPlacement -> 1}, {{$CellContext`mleQ$$, False, "MLE"}, {
         True, False}, ControlPlacement -> 
         2}, {{$CellContext`mapQ$$, True, "MAP"}, {True, False}, 
         ControlPlacement -> 
         3}, {{$CellContext`\[CapitalMu]$$, 9, "order \[CapitalMu]"}, 0, 16, 
         1, Appearance -> {"Labeled"}, ControlPlacement -> 
         4}, {{$CellContext`log\[Sigma]\[Xi]$$, 0.5228787452803376, 
          "log \[Sigma]\[Xi] (KAL)"}, -3, 5, Appearance -> "Labeled", 
         ControlPlacement -> 
         5}, {{$CellContext`log\[Sigma]\[Zeta]$$, -1.1505149978319906`, 
          "log \[Sigma]\[Zeta] (KAL)"}, -5, 3, Appearance -> "Labeled", 
         ControlPlacement -> 6}, 
        Grid[{{
           Grid[{{
              Button[
              "RESET", ($CellContext`\[CapitalMu]$$ = 
                9; $CellContext`log\[Sigma]\[Xi]$$ = Log10[
                  Sqrt[1/0.09]]; $CellContext`log\[Sigma]\[Zeta]$$ = Log10[
                  Sqrt[0.005]])& ], 
              Manipulate`Place[1], 
              Manipulate`Place[2], 
              Manipulate`Place[3]}}]}, {
           Manipulate`Place[4]}, {
           Manipulate`Place[5]}, {
           Manipulate`Place[6]}}]}, "Options" :> {}, "DefaultOptions" :> {}],
     ImageSizeCache->{505., {244., 251.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.729192135929804*^9, 3.7291922278453083`*^9, {3.729193547075082*^9, 
   3.72919357029303*^9}, 3.7291936494538317`*^9, 3.729193835844892*^9, {
   3.7291938917022667`*^9, 3.729193913601519*^9}, 3.7291939518583193`*^9, 
   3.729194031604315*^9, 3.729194077471689*^9, 3.7291957523055468`*^9, {
   3.729196352157159*^9, 3.7291963729616833`*^9}, 3.729196414663275*^9, 
   3.729255939509426*^9, 3.729552302952733*^9, 3.729557877054325*^9, 
   3.72962983964937*^9, 3.729642874169162*^9, 3.7296429101726303`*^9, 
   3.729643940550147*^9, 3.729647187004492*^9, 3.729711729117857*^9, 
   3.729711766418165*^9, 3.7297782664869204`*^9, 3.729779235817174*^9, 
   3.7297793102436247`*^9, 3.729792075793706*^9, 3.729894701595381*^9, 
   3.729896007432908*^9, 
   3.7298961543952217`*^9},ExpressionUUID->"366b3f7d-9d55-44d8-8abf-\
b3869cf72464"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Conclusion", "Chapter",
 CellChangeTimes->{{3.729196441150124*^9, 
  3.7291964428392887`*^9}},ExpressionUUID->"484e6ea0-2a83-4e76-ae3e-\
55e4c02440b7"],

Cell["\<\
We have shown that Kalman folding (KAL) produces the same results as \
renormalized recurrent least squares (RLS) and maximum a-posteriori (MAP) for \
appropriate choices of covariances, i.e., regularization hyperparameters. We \
have further shown (numerically) that MAP produces the same results when its \
hyperparameters are swapped and inverted. 

KAL and RLS offer significant advantages in space-time efficiency by avoiding \
storage and multiplication of large matrices. In all cases, we avoid matrix \
inverses by solving linear systems internally.\
\>", "Text",
 CellChangeTimes->{{3.7291964484304113`*^9, 3.729196613945616*^9}, 
   3.7292030970835457`*^9, {3.72968771341329*^9, 3.729687716858973*^9}, {
   3.729711791511696*^9, 3.72971179468015*^9}, {3.729799002121397*^9, 
   3.729799077001767*^9}},ExpressionUUID->"fa50f462-b494-4355-af76-\
54e3dc27ca45"]
}, Open  ]]
}, Open  ]]
},
WindowSize->{1096, 851},
WindowMargins->{{0, Automatic}, {Automatic, 0}},
PrintingCopies->1,
PrintingStartingPageNumber->1,
PrintingPageRange->{1, Automatic},
TaggingRules->{
 "PaginationCache" -> {{2018, 2, 20, 19, 46, 39.675061`8.351092581673305}, {1,
     1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
     1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3,
     4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 6, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 
    9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 11, 12, 12, 12, 12, 13, 14, 14, 
    15, 15, 17, 17, 19, 19, 19, 20}, Automatic}},
Magnification:>1.25 Inherited,
FrontEndVersion->"11.2 for Mac OS X x86 (32-bit, 64-bit Kernel) (September \
10, 2017)",
StyleDefinitions->FrontEnd`FileName[{$RootDirectory, "Users", "bbeckman"}, 
  "DefaultStyles.nb", CharacterEncoding -> "UTF-8"]
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{
 "c:1"->{
  Cell[1510, 35, 472, 7, 190, "Title",ExpressionUUID->"d98080dc-278f-4830-9197-07efd2633fa4",
   CellTags->"c:1"]},
 "c:10"->{
  Cell[124099, 2736, 256, 3, 80, "Subchapter",ExpressionUUID->"1912c569-4f5c-4ab1-a8eb-275f3be33170",
   CellTags->"c:10"]},
 "c:11"->{
  Cell[134984, 3003, 299, 4, 85, "Chapter",ExpressionUUID->"f91eb7c6-f1c4-49b5-aad9-b2ad30a42547",
   CellTags->"c:11"]},
 "c:12"->{
  Cell[153270, 3421, 195, 2, 80, "Subchapter",ExpressionUUID->"ebd311f1-47cf-4ba5-a57f-c84b66286d57",
   CellTags->"c:12"]},
 "c:13"->{
  Cell[161147, 3609, 461, 6, 85, "Chapter",ExpressionUUID->"f9b31017-4c69-4804-83c7-cedc30bf1885",
   CellTags->"c:13"]},
 "c:14"->{
  Cell[313304, 6976, 181, 2, 85, "Chapter",ExpressionUUID->"3a857b02-02f4-4444-9302-60878b838b66",
   CellTags->"c:14"]},
 "c:15"->{
  Cell[315257, 7028, 241, 3, 80, "Subchapter",ExpressionUUID->"6092c50b-6db9-47d8-930c-78c31ddc0d05",
   CellTags->"c:15"]},
 "c:2"->{
  Cell[4410, 96, 272, 4, 85, "Chapter",ExpressionUUID->"3c14fe8e-8c74-403e-919a-d59e78c17505",
   CellTags->"c:2"]},
 "c:3"->{
  Cell[10268, 209, 228, 3, 85, "Chapter",ExpressionUUID->"acc655e3-2c6d-44c7-a5e2-4f24850f83fb",
   CellTags->"c:3"]},
 "c:4"->{
  Cell[21564, 472, 297, 4, 80, "Subchapter",ExpressionUUID->"16970f90-0ae5-4547-a932-f6511f887bd9",
   CellTags->"c:4"]},
 "c:5"->{
  Cell[24131, 539, 197, 3, 80, "Subchapter",ExpressionUUID->"4d7a0fc5-1456-46d8-85a7-51f164a04474",
   CellTags->"c:5"]},
 "c:6"->{
  Cell[31307, 697, 268, 3, 80, "Subchapter",ExpressionUUID->"d543cb4f-56dc-41e2-9b9a-e595f99ddf99",
   CellTags->"c:6"]},
 "c:7"->{
  Cell[37786, 832, 228, 3, 80, "Subchapter",ExpressionUUID->"7c21db9d-0a3c-4e16-8036-287d7221e622",
   CellTags->"c:7"]},
 "c:8"->{
  Cell[57695, 1260, 325, 4, 80, "Subchapter",ExpressionUUID->"9e404945-3a18-44e2-aeb1-ec425597d11f",
   CellTags->"c:8"]},
 "c:9"->{
  Cell[71110, 1570, 218, 3, 85, "Chapter",ExpressionUUID->"2a93cd2e-fae9-4448-99ff-94f55680bddf",
   CellTags->"c:9"]}
 }
*)
(*CellTagsIndex
CellTagsIndex->{
 {"c:1", 433600, 9628},
 {"c:10", 433727, 9631},
 {"c:11", 433863, 9634},
 {"c:12", 433996, 9637},
 {"c:13", 434132, 9640},
 {"c:14", 434265, 9643},
 {"c:15", 434398, 9646},
 {"c:2", 434533, 9649},
 {"c:3", 434660, 9652},
 {"c:4", 434789, 9655},
 {"c:5", 434921, 9658},
 {"c:6", 435053, 9661},
 {"c:7", 435185, 9664},
 {"c:8", 435317, 9667},
 {"c:9", 435450, 9670}
 }
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1510, 35, 472, 7, 190, "Title",ExpressionUUID->"d98080dc-278f-4830-9197-07efd2633fa4",
 CellTags->"c:1"],
Cell[1985, 44, 395, 9, 86, "Text",ExpressionUUID->"7cf3aefa-42f7-4a77-93d4-058e0c84664a"],
Cell[CellGroupData[{
Cell[2405, 57, 206, 4, 85, "Chapter",ExpressionUUID->"8acf63cd-c62f-4726-abe0-425d6b54818d"],
Cell[2614, 63, 1759, 28, 292, "Text",ExpressionUUID->"f91d8029-0f04-4263-854f-1f318b8699ff"]
}, Open  ]],
Cell[CellGroupData[{
Cell[4410, 96, 272, 4, 85, "Chapter",ExpressionUUID->"3c14fe8e-8c74-403e-919a-d59e78c17505",
 CellTags->"c:2"],
Cell[4685, 102, 5546, 102, 680, "Text",ExpressionUUID->"95303209-19a9-46b4-b2e8-754c3c3dff50"]
}, Open  ]],
Cell[CellGroupData[{
Cell[10268, 209, 228, 3, 85, "Chapter",ExpressionUUID->"acc655e3-2c6d-44c7-a5e2-4f24850f83fb",
 CellTags->"c:3"],
Cell[10499, 214, 1471, 25, 189, "Text",ExpressionUUID->"54f362df-f60e-482e-a1c7-1c9e97a26ec4"],
Cell[CellGroupData[{
Cell[11995, 243, 774, 11, 52, "ItemNumbered",ExpressionUUID->"95439e47-910a-4dca-b38c-a75f8ec21e0d"],
Cell[12772, 256, 738, 10, 52, "ItemNumbered",ExpressionUUID->"ad86a253-cdd7-442a-8329-f48d9394f90e"],
Cell[13513, 268, 737, 10, 52, "ItemNumbered",ExpressionUUID->"767c9503-7598-4cb2-af44-f17424f2cfa1"],
Cell[14253, 280, 852, 13, 52, "ItemNumbered",ExpressionUUID->"d0e1a7c9-95a9-43bd-b642-8f6260b3fff4"]
}, Open  ]],
Cell[15120, 296, 976, 16, 86, "Text",ExpressionUUID->"aa3ac913-c0e3-49b0-a045-d5d44d7ce155"],
Cell[CellGroupData[{
Cell[16121, 316, 165, 3, 80, "Subchapter",ExpressionUUID->"0c44a683-0d5b-4886-b75e-504c0d98a960"],
Cell[16289, 321, 3073, 85, 219, "Text",ExpressionUUID->"358c38cb-da9b-497b-888a-d2c3526ecc8f"],
Cell[19365, 408, 2162, 59, 133, "DisplayFormulaNumbered",ExpressionUUID->"7670c17b-1586-49cb-811e-f9d6e711742b"]
}, Open  ]],
Cell[CellGroupData[{
Cell[21564, 472, 297, 4, 80, "Subchapter",ExpressionUUID->"16970f90-0ae5-4547-a932-f6511f887bd9",
 CellTags->"c:4"],
Cell[21864, 478, 1667, 37, 140, "Text",ExpressionUUID->"3c5928ca-5308-4a06-8fb9-200938bdc108"],
Cell[23534, 517, 560, 17, 78, "Input",ExpressionUUID->"0c0d0138-50fd-4e04-ac62-6a9945dc8b11"]
}, Open  ]],
Cell[CellGroupData[{
Cell[24131, 539, 197, 3, 80, "Subchapter",ExpressionUUID->"4d7a0fc5-1456-46d8-85a7-51f164a04474",
 CellTags->"c:5"],
Cell[24331, 544, 1589, 38, 114, "Text",ExpressionUUID->"a86b4f51-45ea-41db-81c3-c906e76e98d5"],
Cell[CellGroupData[{
Cell[25945, 586, 1891, 42, 156, "Input",ExpressionUUID->"ee0a7bb0-e686-4680-8f50-8cd48901d6c9"],
Cell[27839, 630, 3419, 61, 92, "Output",ExpressionUUID->"b1bcc1a4-5ac7-4cb7-94d4-4276cdb1fbcd"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[31307, 697, 268, 3, 80, "Subchapter",ExpressionUUID->"d543cb4f-56dc-41e2-9b9a-e595f99ddf99",
 CellTags->"c:6"],
Cell[31578, 702, 368, 9, 61, "Text",ExpressionUUID->"00b3e53e-95b5-45e0-8e9c-e7a4e956d924"],
Cell[31949, 713, 1120, 28, 156, "Input",ExpressionUUID->"70f226dc-2403-422b-80b0-330c3808ce1b"],
Cell[CellGroupData[{
Cell[33094, 745, 1434, 28, 130, "Input",ExpressionUUID->"0929a7fb-31dd-4475-b0d2-197746a7e8b6"],
Cell[34531, 775, 3206, 51, 65, "Output",ExpressionUUID->"f96452d9-d7e6-45e2-8518-33d32596704e"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[37786, 832, 228, 3, 80, "Subchapter",ExpressionUUID->"7c21db9d-0a3c-4e16-8036-287d7221e622",
 CellTags->"c:7"],
Cell[38017, 837, 1945, 53, 107, "Text",ExpressionUUID->"bd354014-b75f-4675-8ab3-724f527b1594"],
Cell[CellGroupData[{
Cell[39987, 894, 916, 22, 104, "Input",ExpressionUUID->"76e88281-275e-4110-b9de-c863257070c2"],
Cell[40906, 918, 2661, 40, 51, "Output",ExpressionUUID->"55122cef-62a3-4c79-90d9-3bab49faeaff"]
}, Open  ]],
Cell[43582, 961, 397, 8, 60, "Text",ExpressionUUID->"361c3e32-0911-48e5-969d-f5beffe36997"],
Cell[43982, 971, 649, 15, 51, "Input",ExpressionUUID->"a6371160-8048-46ae-aa8e-bd8961e1a367"],
Cell[44634, 988, 266, 6, 60, "Text",ExpressionUUID->"3c5df78b-04eb-428e-b4d9-3c4d55925c73"],
Cell[CellGroupData[{
Cell[44925, 998, 247, 6, 51, "Input",ExpressionUUID->"a269ae56-83b8-492b-9dbe-38b9fbc7dee0"],
Cell[45175, 1006, 1166, 27, 84, "Output",ExpressionUUID->"3e92a4c9-c090-47ae-87ad-2bfef954f258"]
}, Open  ]],
Cell[46356, 1036, 767, 17, 113, "Text",ExpressionUUID->"cc694cdf-4bf6-46fe-90f0-a64592f7d1d2"],
Cell[CellGroupData[{
Cell[47148, 1057, 986, 25, 78, "Input",ExpressionUUID->"8ce751c4-9067-4ce1-9f23-7acdbaf97716"],
Cell[48137, 1084, 9509, 170, 309, "Output",ExpressionUUID->"da042fbb-b4a7-4659-b742-e335c2ce7ca1"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[57695, 1260, 325, 4, 80, "Subchapter",ExpressionUUID->"9e404945-3a18-44e2-aeb1-ec425597d11f",
 CellTags->"c:8"],
Cell[58023, 1266, 2362, 55, 120, "Text",ExpressionUUID->"4e07dc3c-bfe5-4ba2-a5fc-b9cd0f13e220"],
Cell[60388, 1323, 755, 17, 33, "DisplayFormulaNumbered",ExpressionUUID->"b895f84f-c47c-4a90-a492-0e50bb672b17"],
Cell[61146, 1342, 324, 6, 60, "Text",ExpressionUUID->"b3fba6d0-26c1-42c1-a388-b3e7d55c48ff"],
Cell[CellGroupData[{
Cell[61495, 1352, 378, 9, 51, "Input",ExpressionUUID->"133ad946-91dc-4f78-a345-ce69827bf5cb"],
Cell[61876, 1363, 2464, 38, 51, "Output",ExpressionUUID->"dc9472d4-be58-4364-8d1f-c5ca7ba70245"]
}, Open  ]],
Cell[CellGroupData[{
Cell[64377, 1406, 175, 3, 41, "Subsection",ExpressionUUID->"76033957-f3cc-4406-ae95-a9107e9b01e9"],
Cell[64555, 1411, 699, 20, 87, "Text",ExpressionUUID->"a17e8e76-4c4a-456e-a800-99230c07f26c"],
Cell[CellGroupData[{
Cell[65279, 1435, 285, 8, 51, "Input",ExpressionUUID->"01d5013c-6e52-4ad2-83e4-c664df66f030"],
Cell[65567, 1445, 2249, 34, 51, "Output",ExpressionUUID->"f6eec804-86f4-4a9b-bed3-70570f31a313"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[67865, 1485, 168, 3, 41, "Subsection",ExpressionUUID->"e51e3bb5-9f1d-461b-82b9-a629644e78d3"],
Cell[68036, 1490, 459, 10, 61, "Text",ExpressionUUID->"9f17f33b-f15e-49bc-91f5-a3a049be2bc7"],
Cell[CellGroupData[{
Cell[68520, 1504, 350, 9, 51, "Input",ExpressionUUID->"1ae0bc2a-89a7-4487-8b0b-38a63c9f9d50"],
Cell[68873, 1515, 761, 14, 51, "Output",ExpressionUUID->"9792fc6e-42ac-4882-8686-03b40a96c48a"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[69683, 1535, 195, 3, 41, "Subsection",ExpressionUUID->"a03000c1-fcb9-4707-9571-4867f157d100"],
Cell[69881, 1540, 1168, 23, 87, "Text",ExpressionUUID->"fe3fcfea-7630-4754-b191-17a984a29511"]
}, Open  ]]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[71110, 1570, 218, 3, 85, "Chapter",ExpressionUUID->"2a93cd2e-fae9-4448-99ff-94f55680bddf",
 CellTags->"c:9"],
Cell[71331, 1575, 938, 21, 61, "Text",ExpressionUUID->"098b2a28-cc9e-454c-aaa3-8401cdd7dc9b"],
Cell[72272, 1598, 1096, 28, 61, "DisplayFormulaNumbered",ExpressionUUID->"8c9b8880-133c-4ffa-b013-ff69aead1159"],
Cell[73371, 1628, 1281, 18, 60, "Text",ExpressionUUID->"93e3d34c-92db-4ddf-8583-f7d39262a44e"],
Cell[CellGroupData[{
Cell[74677, 1650, 1552, 26, 53, "Item",ExpressionUUID->"899961b0-dc4b-4a8d-a91a-7838306ffeb7"],
Cell[76232, 1678, 1782, 34, 53, "Item",ExpressionUUID->"f2dff4c4-6938-4386-b5b0-b9bcc3219bab"],
Cell[78017, 1714, 1608, 29, 53, "Item",ExpressionUUID->"66c566e3-4f1a-4ccf-bc11-2b5cc669341b"]
}, Open  ]],
Cell[CellGroupData[{
Cell[79662, 1748, 167, 3, 41, "Subsection",ExpressionUUID->"c1da9886-0928-41f5-bdfc-310d1668dba2"],
Cell[79832, 1753, 1571, 23, 60, "Text",ExpressionUUID->"86467c14-4fa6-426a-86c5-cfa931632401"],
Cell[81406, 1778, 1961, 36, 37, "DisplayFormulaNumbered",ExpressionUUID->"f1279179-caa6-4e3b-817d-316c8cd857bf"],
Cell[83370, 1816, 1603, 22, 60, "Text",ExpressionUUID->"8af654ba-7edd-4480-97af-b1cff2d92cc2"],
Cell[84976, 1840, 1799, 31, 33, "DisplayFormulaNumbered",ExpressionUUID->"acbe4f6c-05ff-4b15-98b7-3273232da17b"],
Cell[86778, 1873, 1646, 29, 60, "Text",ExpressionUUID->"fca13932-3ef6-481e-958c-4a5343bf7bb3"],
Cell[88427, 1904, 2712, 57, 33, "DisplayFormulaNumbered",ExpressionUUID->"bbc114f3-8eed-40b1-8d10-6df69eae15a9"],
Cell[91142, 1963, 4441, 96, 247, "Text",ExpressionUUID->"1fd06721-76a5-4cff-8458-cd6120f94b95"]
}, Open  ]],
Cell[CellGroupData[{
Cell[95620, 2064, 173, 3, 41, "Subsection",ExpressionUUID->"c6ec5072-c52b-499f-92b9-04355eb5c271"],
Cell[95796, 2069, 2305, 51, 62, "Text",ExpressionUUID->"e5a9ce1e-e00e-4f54-b85d-081e278adf90"],
Cell[CellGroupData[{
Cell[98126, 2124, 3855, 88, 318, "Input",ExpressionUUID->"8ffe4223-18a0-41f6-90b1-bb8a0ab30bb3"],
Cell[101984, 2214, 2867, 60, 70, "Output",ExpressionUUID->"e9e6e525-be23-44b2-8d6e-e32c219796fa"]
}, Open  ]],
Cell[104866, 2277, 1320, 30, 88, "Text",ExpressionUUID->"76e4229a-4899-4e33-9a86-b1ec1ee6041b"]
}, Open  ]],
Cell[CellGroupData[{
Cell[106223, 2312, 164, 3, 41, "Subsection",ExpressionUUID->"a3d23e39-8323-41fa-be6c-d242fd29b800"],
Cell[106390, 2317, 1037, 19, 113, "Text",ExpressionUUID->"43736b1c-cf5c-4aac-a310-90396ff4ff12"]
}, Open  ]],
Cell[CellGroupData[{
Cell[107464, 2341, 176, 3, 41, "Subsection",ExpressionUUID->"5e5972fa-092f-4c1c-aa76-6ecda346cfcd"],
Cell[107643, 2346, 1972, 48, 142, "Text",ExpressionUUID->"daf0d49a-a2c9-4587-a3ca-ede99b1d9b3f"]
}, Open  ]],
Cell[CellGroupData[{
Cell[109652, 2399, 166, 3, 41, "Subsection",ExpressionUUID->"92402a7d-2756-4c5d-be35-ef9c170940bf"],
Cell[109821, 2404, 1666, 42, 88, "Text",ExpressionUUID->"10e22b32-ce63-43e0-bbc1-2dfce689e1aa"],
Cell[CellGroupData[{
Cell[111512, 2450, 304, 7, 51, "Input",ExpressionUUID->"173e6770-4fcf-4050-8c85-581d158fe040"],
Cell[111819, 2459, 1954, 32, 55, "Output",ExpressionUUID->"bc555716-12ca-4fb9-ac16-0cd7c7a5776b"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[113822, 2497, 176, 3, 41, "Subsection",ExpressionUUID->"1a673c1c-26f1-4725-80e3-2d8a09b083a1"],
Cell[114001, 2502, 3063, 76, 174, "Text",ExpressionUUID->"b538cb3d-0085-4200-af18-f2ded85ec33e"],
Cell[CellGroupData[{
Cell[117089, 2582, 915, 22, 100, "Input",ExpressionUUID->"1f9a3581-c198-4dfa-9dbe-9a0cf6381314"],
Cell[118007, 2606, 2555, 46, 84, "Output",ExpressionUUID->"33362cd6-9316-4c21-b217-a96ba45cfce3"]
}, Open  ]],
Cell[120577, 2655, 596, 13, 61, "Text",ExpressionUUID->"c4e7898d-3f04-4052-99b7-cabf5e20de7a"],
Cell[CellGroupData[{
Cell[121198, 2672, 441, 12, 51, "Input",ExpressionUUID->"1b94fc87-4314-42b6-9ece-45f09bed4510"],
Cell[121642, 2686, 2408, 44, 84, "Output",ExpressionUUID->"4e1e1118-2272-41d6-8ef0-b67b2bae9b92"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[124099, 2736, 256, 3, 80, "Subchapter",ExpressionUUID->"1912c569-4f5c-4ab1-a8eb-275f3be33170",
 CellTags->"c:10"],
Cell[124358, 2741, 2004, 51, 140, "Text",ExpressionUUID->"ce7f532e-10a9-4ecb-81ed-f827034f82d4"],
Cell[CellGroupData[{
Cell[126387, 2796, 3689, 90, 292, "Input",ExpressionUUID->"b1e59138-e589-488f-8c5d-71dba55ef40c"],
Cell[130079, 2888, 2883, 60, 70, "Output",ExpressionUUID->"aa39f1a1-8476-4d14-8fbd-8d9906d28b15"]
}, Open  ]],
Cell[132977, 2951, 723, 14, 87, "Text",ExpressionUUID->"95bdda6c-c145-4242-952f-9526a2ce40d1"]
}, Open  ]],
Cell[CellGroupData[{
Cell[133737, 2970, 167, 3, 80, "Subchapter",ExpressionUUID->"874a0d70-ffe7-4685-a3ec-da2ffeb72352"],
Cell[133907, 2975, 1028, 22, 113, "Text",ExpressionUUID->"b52fa788-ec4d-43d5-b1c4-0b86cba20048"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[134984, 3003, 299, 4, 85, "Chapter",ExpressionUUID->"f91eb7c6-f1c4-49b5-aad9-b2ad30a42547",
 CellTags->"c:11"],
Cell[135286, 3009, 1138, 32, 113, "Text",ExpressionUUID->"8045eba4-2d5b-4de2-b703-f9d7b10bf773"],
Cell[136427, 3043, 5483, 109, 193, "Text",ExpressionUUID->"d51c79dd-7095-49f4-a087-5de531619caf"],
Cell[141913, 3154, 1256, 29, 61, "DisplayFormulaNumbered",ExpressionUUID->"17fcc972-1a28-4152-bd4f-535d91af5fb4"],
Cell[143172, 3185, 654, 13, 87, "Text",ExpressionUUID->"aeb51f37-12c8-4881-83e6-2ef32a5566f2"],
Cell[CellGroupData[{
Cell[143851, 3202, 326, 8, 51, "Input",ExpressionUUID->"b7997bf6-125e-4ff5-af74-8ba42a25df9c"],
Cell[144180, 3212, 2451, 54, 92, "Output",ExpressionUUID->"595932c1-704d-4dab-9336-6e04eaded33d"]
}, Open  ]],
Cell[CellGroupData[{
Cell[146668, 3271, 2840, 72, 246, "Input",ExpressionUUID->"e85911fe-41be-4e69-b677-7c46716d0a38"],
Cell[149511, 3345, 3722, 71, 70, "Output",ExpressionUUID->"b6ac41a7-d21f-46ec-b576-e61c49a57b2f"]
}, Open  ]],
Cell[CellGroupData[{
Cell[153270, 3421, 195, 2, 80, "Subchapter",ExpressionUUID->"ebd311f1-47cf-4ba5-a57f-c84b66286d57",
 CellTags->"c:12"],
Cell[153468, 3425, 7630, 178, 330, "Text",ExpressionUUID->"41beab53-931e-4488-9640-8fde40e31d33"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[161147, 3609, 461, 6, 85, "Chapter",ExpressionUUID->"f9b31017-4c69-4804-83c7-cedc30bf1885",
 CellTags->"c:13"],
Cell[161611, 3617, 2556, 45, 266, "Text",ExpressionUUID->"bac2eec7-91af-482b-a9c6-441d231b5ff2"],
Cell[CellGroupData[{
Cell[164192, 3666, 195, 3, 80, "Subchapter",ExpressionUUID->"009ef6d9-eac5-46fd-8499-4634049578f0"],
Cell[CellGroupData[{
Cell[164412, 3673, 188, 3, 41, "Subsection",ExpressionUUID->"dcb9de58-4cb4-4b3d-9973-93e56920e6cf"],
Cell[164603, 3678, 926, 24, 61, "Text",ExpressionUUID->"8cc4ab5b-c258-42b9-830e-cdb7977ec279"],
Cell[CellGroupData[{
Cell[165554, 3706, 888, 19, 104, "Input",ExpressionUUID->"9ce0172d-e3e2-49fe-948d-a7440920e3d7"],
Cell[166445, 3727, 2706, 58, 315, "Output",ExpressionUUID->"3da08222-e167-445f-9ccd-c641bfe3b1f7"]
}, Open  ]],
Cell[169166, 3788, 1651, 30, 217, "Text",ExpressionUUID->"2f0bd73f-7302-45b7-869a-26b1cfd704e5"],
Cell[170820, 3820, 1261, 34, 182, "Input",ExpressionUUID->"7d239325-5255-4a02-914c-77c2e44493a6"],
Cell[172084, 3856, 1331, 24, 88, "Text",ExpressionUUID->"1fa8518e-d009-47f2-9b22-0cde66c155b5"],
Cell[173418, 3882, 1549, 39, 208, "Input",ExpressionUUID->"f2f8376d-e871-49ff-849f-33fbb3198b3a"],
Cell[174970, 3923, 307, 5, 60, "Text",ExpressionUUID->"1a6df779-bf83-4dc6-849b-3173a942be9a"],
Cell[CellGroupData[{
Cell[175302, 3932, 2461, 55, 208, "Input",ExpressionUUID->"c5589eba-8522-4e1e-acb7-54174e91a05d"],
Cell[177766, 3989, 16458, 293, 318, "Output",ExpressionUUID->"95dc61d2-8828-4d02-9689-48a500d62af5"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[194273, 4288, 195, 3, 41, "Subsection",ExpressionUUID->"23dbd351-27ff-4dfe-b5df-4bf18e84e52d"],
Cell[194471, 4293, 555, 12, 61, "Text",ExpressionUUID->"fc8d2ebf-e5bd-4f37-84a7-0a0d1a14e585"],
Cell[CellGroupData[{
Cell[195051, 4309, 1403, 37, 139, "Input",ExpressionUUID->"5d13c4a6-9ba4-485a-8b9a-60596bd63d30"],
Cell[196457, 4348, 2586, 54, 120, "Output",ExpressionUUID->"0a6690b2-cf47-421a-b393-debee3f8c1c4"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[199092, 4408, 169, 3, 41, "Subsection",ExpressionUUID->"a57e1e06-d89f-4a6b-90ba-b18e5094f5ad"],
Cell[199264, 4413, 737, 16, 61, "Text",ExpressionUUID->"83a04645-300b-4fe9-9950-859db8a309da"],
Cell[200004, 4431, 1012, 33, 66, "DisplayFormula",ExpressionUUID->"fad6048c-0c22-4427-bb8f-a76fd37cf669"],
Cell[201019, 4466, 2521, 66, 193, "Text",ExpressionUUID->"0c885e1c-6623-47a5-a15d-b5a4815ad482"],
Cell[203543, 4534, 880, 34, 33, "DisplayFormula",ExpressionUUID->"947be109-cf62-4de3-b545-15552e17c03f"],
Cell[204426, 4570, 3005, 77, 165, "Text",ExpressionUUID->"c606c9be-2b65-497c-bd37-9ab63b1d0d1f"],
Cell[CellGroupData[{
Cell[207456, 4651, 1590, 34, 55, "Item",ExpressionUUID->"dd275c33-9123-49bb-8d04-f932e3ad2a1e"],
Cell[209049, 4687, 1825, 40, 54, "Item",ExpressionUUID->"2948af39-64bd-4f21-92f5-546f15547f6c"],
Cell[210877, 4729, 1075, 21, 54, "Item",ExpressionUUID->"1a7d225e-8728-4deb-8507-28528fd81c64"]
}, Open  ]],
Cell[211967, 4753, 1890, 41, 167, "Text",ExpressionUUID->"e56a234a-c338-4d71-95b0-1a2237f07f34"],
Cell[213860, 4796, 2321, 59, 110, "DisplayFormulaNumbered",ExpressionUUID->"28724abb-f182-4a4b-adef-e0815b06b267"],
Cell[216184, 4857, 311, 9, 61, "Text",ExpressionUUID->"63d79e64-ad79-4eab-8e8a-3dac9bf37b90"],
Cell[216498, 4868, 2928, 83, 104, "DisplayFormulaNumbered",ExpressionUUID->"c4a251c0-8d8d-4e74-8c68-ffaf8aa9cd31"]
}, Open  ]],
Cell[CellGroupData[{
Cell[219463, 4956, 173, 3, 41, "Subsection",ExpressionUUID->"5f2495bd-b24f-45ea-b35c-1826a1fd64de"],
Cell[219639, 4961, 531, 10, 60, "Text",ExpressionUUID->"21b0dd02-714b-44f4-ac59-02773fa48214"],
Cell[CellGroupData[{
Cell[220195, 4975, 1603, 37, 156, "Input",ExpressionUUID->"8a92f292-23d6-4b9f-857f-d8aefa40f0ef"],
Cell[221801, 5014, 1684, 27, 51, "Output",ExpressionUUID->"7d9f90d5-dbe2-4687-876c-d3f1bc1e87c1"]
}, Open  ]],
Cell[223500, 5044, 165, 3, 60, "Text",ExpressionUUID->"14fa37f8-7761-4b0c-a6d8-0ce6d583ed9e"],
Cell[223668, 5049, 674, 17, 104, "Input",ExpressionUUID->"a9e420a7-fe1c-47bd-8013-211fefd7186e"],
Cell[224345, 5068, 634, 11, 112, "Text",ExpressionUUID->"c2b4e56e-ae3e-417c-adc6-88d8b9431bf8"],
Cell[CellGroupData[{
Cell[225004, 5083, 966, 24, 130, "Input",ExpressionUUID->"40d44984-88b8-4065-93d5-cb6661f37f21"],
Cell[225973, 5109, 2870, 52, 159, "Output",ExpressionUUID->"1d5bb5d2-9fee-4d7d-90b1-08c8eee7b15c"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[228892, 5167, 174, 3, 41, "Subsection",ExpressionUUID->"06f61c7b-bc70-40f6-9d67-5f09cca5a053"],
Cell[229069, 5172, 1320, 22, 164, "Text",ExpressionUUID->"0c8046a6-3793-4992-8eef-7857084afc25"],
Cell[CellGroupData[{
Cell[230414, 5198, 3822, 86, 320, "Input",ExpressionUUID->"321867e2-1653-4ec6-af92-6b562f33b3f5"],
Cell[234239, 5286, 3602, 63, 159, "Output",ExpressionUUID->"3d513721-71b2-4687-b177-32cd68e63f3c"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[237890, 5355, 228, 4, 41, "Subsection",ExpressionUUID->"9eb483dd-0180-493c-a977-ac685cf1c40a"],
Cell[238121, 5361, 2713, 63, 219, "Text",ExpressionUUID->"838c6545-97a4-4160-9864-965a1cc36310"],
Cell[240837, 5426, 5228, 122, 416, "Input",ExpressionUUID->"52c7028b-b963-44ab-bbc6-a0ee75a7e853"]
}, Open  ]],
Cell[CellGroupData[{
Cell[246102, 5553, 161, 3, 41, "Subsection",ExpressionUUID->"ce8fa48f-f674-4703-a6d9-8192c2b551c5"],
Cell[246266, 5558, 3434, 80, 379, "Text",ExpressionUUID->"4cf55009-8939-444f-a697-a490a12a616e"],
Cell[CellGroupData[{
Cell[249725, 5642, 13812, 297, 803, "Input",ExpressionUUID->"3a5fce84-880e-478b-8c46-78e94eac9275"],
Cell[263540, 5941, 7551, 148, 527, "Output",ExpressionUUID->"ded1f429-ae28-4582-834e-2bfd46f9b682"]
}, Open  ]]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[271152, 6096, 262, 4, 80, "Subchapter",ExpressionUUID->"5f346f92-37a2-4867-8d13-e9fb4fd1ac60"],
Cell[271417, 6102, 1843, 32, 191, "Text",ExpressionUUID->"755d7272-a91b-4e07-b81c-0a073922e997"],
Cell[CellGroupData[{
Cell[273285, 6138, 13446, 280, 603, "Input",ExpressionUUID->"717ad15f-345b-4b83-90a7-88eb7bd2a767"],
Cell[286734, 6420, 7105, 139, 527, "Output",ExpressionUUID->"0490c7d1-0cc0-4789-9259-c5148960fa40"]
}, Open  ]],
Cell[CellGroupData[{
Cell[293876, 6564, 229, 4, 41, "Subsection",ExpressionUUID->"8b88ef07-0816-4d11-9d31-09ce829acbee"],
Cell[294108, 6570, 2274, 46, 194, "Text",ExpressionUUID->"ce468a6b-efd8-447b-925e-20cb29496461"],
Cell[CellGroupData[{
Cell[296407, 6620, 10985, 230, 679, "Input",ExpressionUUID->"985a63ca-302c-4f24-8d5d-5a231996a4f5"],
Cell[307395, 6852, 4532, 89, 303, "Output",ExpressionUUID->"be2c524d-5677-4bbf-bb9a-ab58d5ab9d86"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[311976, 6947, 259, 4, 41, "Subsection",ExpressionUUID->"be355efe-81b9-4077-add8-cf60273c9546"],
Cell[312238, 6953, 1005, 16, 112, "Text",ExpressionUUID->"fa965554-b77d-42f6-898d-053620725a95"]
}, Open  ]]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[313304, 6976, 181, 2, 85, "Chapter",ExpressionUUID->"3a857b02-02f4-4444-9302-60878b838b66",
 CellTags->"c:14"],
Cell[313488, 6980, 1744, 44, 114, "Text",ExpressionUUID->"62f80a97-9d18-4705-8ec3-21b92ba1ba14"],
Cell[CellGroupData[{
Cell[315257, 7028, 241, 3, 80, "Subchapter",ExpressionUUID->"6092c50b-6db9-47d8-930c-78c31ddc0d05",
 CellTags->"c:15"],
Cell[315501, 7033, 1303, 29, 88, "Text",ExpressionUUID->"0eb3be5c-6ad1-4698-89d4-abf74f39cd4d"],
Cell[316807, 7064, 766, 20, 61, "DisplayFormulaNumbered",ExpressionUUID->"4049a1f2-9c54-41f2-b358-29df90610bc1"],
Cell[317576, 7086, 698, 18, 33, "DisplayFormulaNumbered",ExpressionUUID->"1e604de0-c480-422c-98f9-a52ec6dcd1bf"],
Cell[318277, 7106, 907, 25, 61, "DisplayFormulaNumbered",ExpressionUUID->"c1232a65-83af-4c7f-9ee3-c6e3459170d5"],
Cell[319187, 7133, 294, 7, 60, "Text",ExpressionUUID->"641604c9-a9b1-4fe3-99e8-e2170a8aec43"],
Cell[319484, 7142, 653, 17, 61, "DisplayFormulaNumbered",ExpressionUUID->"8c251b39-002c-42ca-953a-b8b5377cb443"],
Cell[320140, 7161, 616, 19, 42, "DisplayFormulaNumbered",ExpressionUUID->"9155b152-4123-446a-be5f-d826a88375df"],
Cell[CellGroupData[{
Cell[320781, 7184, 168, 3, 41, "Subsection",ExpressionUUID->"dac7c078-3691-4ca0-b55d-7f5b5f8e8bde"],
Cell[320952, 7189, 3402, 73, 167, "Text",ExpressionUUID->"e8a66e23-4f91-4ac0-ba53-1b2492f56003"],
Cell[CellGroupData[{
Cell[324379, 7266, 1848, 40, 113, "Input",ExpressionUUID->"1b66ed75-d4a2-4cfb-9759-96f00155ca58"],
Cell[326230, 7308, 7920, 211, 216, "Output",ExpressionUUID->"1c80014a-c38e-4d25-b1a8-4e47fad39fab"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[334199, 7525, 159, 3, 41, "Subsection",ExpressionUUID->"883300ba-e7ed-4f38-ba6b-0e7f7a38512c"],
Cell[334361, 7530, 387, 6, 60, "Text",ExpressionUUID->"27c93b4c-9606-4346-ab56-2f57deeaa0aa"],
Cell[334751, 7538, 1837, 43, 130, "Input",ExpressionUUID->"680baf0e-7cff-46d2-810b-4e9f79446c8b"]
}, Open  ]],
Cell[CellGroupData[{
Cell[336625, 7586, 160, 3, 41, "Subsection",ExpressionUUID->"7504cef4-c129-460b-b81b-6105e1ea5faa"],
Cell[336788, 7591, 306, 5, 60, "Text",ExpressionUUID->"6f8a63dc-0b9a-491f-8b1f-c838bdace2b0"],
Cell[337097, 7598, 3885, 71, 208, "Input",ExpressionUUID->"6a03cb85-7c1e-4eb7-aa65-7b2bc06e6962"]
}, Open  ]],
Cell[CellGroupData[{
Cell[341019, 7674, 339, 5, 41, "Subsection",ExpressionUUID->"539b802e-4314-4a1d-8505-50bde2db22c0"],
Cell[341361, 7681, 2781, 71, 254, "Text",ExpressionUUID->"b83890a5-a53b-45f1-a41f-d53e431dc82f"],
Cell[CellGroupData[{
Cell[344167, 7756, 10445, 175, 285, "Input",ExpressionUUID->"d911fd00-b65e-46fb-8843-b073f43301ac"],
Cell[354615, 7933, 3713, 73, 381, "Output",ExpressionUUID->"79648570-282c-43af-90ae-c6ef62ebda84"]
}, Open  ]],
Cell[358343, 8009, 5275, 142, 416, "Text",ExpressionUUID->"586406c3-dd60-45ee-b931-47618b95d6e7"],
Cell[363621, 8153, 3435, 83, 377, "Input",ExpressionUUID->"f438e33b-fa2b-4bdc-a27a-eefd45f72ad4"],
Cell[CellGroupData[{
Cell[367081, 8240, 21232, 425, 946, "Input",ExpressionUUID->"b5552447-0736-4862-b0e5-cec4e106c450"],
Cell[388316, 8667, 10646, 202, 589, "Output",ExpressionUUID->"aa8e5bb6-b1af-4701-b70e-6c67088c0125"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[399011, 8875, 170, 2, 41, "Subsection",ExpressionUUID->"f9d182b7-2ea0-4aa4-858d-e1d52a7855f1"],
Cell[399184, 8879, 1211, 30, 87, "Text",ExpressionUUID->"a68e9f71-53f7-405c-9f44-8b8c664da203"],
Cell[400398, 8911, 1401, 36, 135, "Input",ExpressionUUID->"a5b4f1d7-f50f-4606-8d82-719fa8c626fa"],
Cell[401802, 8949, 2945, 74, 196, "Text",ExpressionUUID->"0b5b81b7-be5c-4486-a0ed-f498beaa94fa"],
Cell[CellGroupData[{
Cell[404772, 9027, 17756, 371, 1050, "Input",ExpressionUUID->"47a4767a-c2e8-4fe7-9b95-1f656995693b"],
Cell[422531, 9400, 8800, 171, 527, "Output",ExpressionUUID->"366b3f7d-9d55-44d8-8abf-b3869cf72464"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[431404, 9579, 157, 3, 85, "Chapter",ExpressionUUID->"484e6ea0-2a83-4e76-ae3e-55e4c02440b7"],
Cell[431564, 9584, 878, 15, 189, "Text",ExpressionUUID->"fa50f462-b494-4355-af76-54e3dc27ca45"]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature 1wp4NOpNErEDpDgfr#V1HKFH *)
