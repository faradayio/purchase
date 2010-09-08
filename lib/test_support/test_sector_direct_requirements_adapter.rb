module BrighterPlanet
  module Purchase
    class TestSectorDirectRequirementsAdapter
      def self.matrix
        Matrix[*data]
      end

      def self.data
        matrix_text = <<-MATRIX
|  X  |          1           |         10          |         11          |         12          |         13          |         14          |         15          |         16          |         17          |         18          |         19          |          2          |         20          |         21          |         22          |         23          |         24          |         25          |         26          |          3          |          4          |        44100        |        44102        |        44103        |        44104        |       44105        |          5          |          6          |          7          |          8          |          9          |          A          |           B           |           C           |           D           |
|  1  |   1.11660147325124   |  0.251599615658254  |  0.373774515688194  |  0.49894260973828   |  0.526839445017405  |  0.50533975009216   |  0.536592476995616  |  0.537767202953766  |  0.538565319780854  |  0.539575777502643  |  0.509735365850664  |  0.528275313128452  |  0.53114006519536   |  0.530216618045907  |  0.527171283798139  |   0.5252186048262   |  0.525470221157555  |  0.522429651950689  |  0.515468420725235  |  0.501915252111428  |  0.420989361897459  |  0.464897922343403  |  0.446150323797142  |  0.419189862221039  |  0.381775901565955  | 0.196865497902236  | 0.0238224813015868 | 0.0235988888362268 | 0.0233757422182553 | 0.023153040115459  | 0.0229307812009271 | 0.021625365692315  | 0.000825976713963838 | 0.000751615465658293 | 0.000843563079940414 |
| 10  |  0.125262243121322   |  1.22952510962239   |  0.370110059652035  |  0.494051015525159  |  0.521674352419195  |  0.500385438816747  |  0.531331766436835  |  0.532494975473827  |  0.533285267626139  |  0.534285818899676  |  0.504737960303109  |  0.523096143391899  |  0.525932809654229  |  0.525018415908202  |  0.52200293787855   |   0.5200694028181   |  0.520318552322677  |  0.517307792617839  |  0.510414808757341  |  0.49699451434563   |  0.416862015212189  |  0.46034009957533   |  0.441776301014817  |  0.415080157689461  |  0.37803300057021   | 0.194935444001234  | 0.0235889275633359 | 0.0233675271809696 | 0.0231465682749391 | 0.0229260495260918 | 0.0227059696205258 | 0.0214133523031747 | 0.000817878903042624 | 0.000744246686583212 | 0.000835292853666488 |
| 11  |  0.156149281881415   |  0.310606386989918  |  1.43230986305468   |  0.61617110878513   |  0.647081078444029  |  0.615276049268739  |  0.650534310068097  |  0.647919897130358  |  0.646052451420649  |  0.644990940676493  |  0.727808979721915  |  0.655795603491823  |  0.66345364645156   |  0.665538027750066  |  0.671449101309309  |  0.674607046088545  |  0.666199646822493  |  0.664196130024955  |  0.656854500308926  |  0.639594320146738  |  0.536114277488773  |  0.592280180418301  |  0.568359857457187  |  0.533976085249523  |  0.486349236217753  | 0.250780821745999  | 0.0303467164155268 | 0.0300618889429797 | 0.0297776294215245 | 0.0294939361540962 | 0.029210807450384  | 0.0275478793220013 | 0.00105218599134002  | 0.000957459514863257 | 0.00107458871481431  |
| 12  |  0.154647846478709   |  0.307619787115015  |  0.456999191294535  |  1.57178484812373   |  0.640859144997452  |  0.609359933410386  |  0.644279172471288  |  0.64168989811949   |  0.639840408618527  |  0.638789104708449  |  0.720810816455358  |  0.649489876535171  |  0.657074284466449  |  0.659138623637085  |  0.664992859950566  |  0.668120439876155  |  0.659793880987661  |  0.657809628774715  |  0.65053859165211   |  0.633444374760712  |  0.53095933251292   |  0.586585178683509  |  0.562894858827791  |  0.528841699814431  |  0.48167280125412   | 0.248369467690749  | 0.0300549210653775 | 0.029772832318528  | 0.0294913060617022 | 0.0292103406141529 | 0.0289299343018226 | 0.027282995866982  | 0.00104206881834637  | 0.000948253173374187 | 0.00106425613101802  |
| 13  |  0.184449553718395   |  0.366933853087441  |  0.545117239239925  |  0.728080450188034  |  1.71418420752924   |  0.720077272820542  |  0.759079531162292  |  0.752822907504661  |  0.748425811534256  |  0.736120970326851  |  0.842038876483725  |  0.879228980066539  |  0.789376574276721  |  0.794346046748593  |  0.808981868658016  |  0.818330415474245  |  0.800655891515154  |  0.799747435861132  |  0.792152623613159  |  0.771434035794818  |  0.646283812510399  |  0.714207869066124  |  0.685342219410289  |  0.643842308115151  |  0.586444669354947  | 0.302386280828225  | 0.036591437289149  | 0.0362479982673708 | 0.0359052440691654 | 0.0355631726482472 | 0.0352217819664751 | 0.0332166579361551 | 0.00126870390824032  | 0.00115448469993586  | 0.00129571664463958  |
| 14  |  0.182709463588976   |  0.363472212963975  |  0.539974623775398  |  0.721211766695694  |  0.754616431986516  |  1.65668031741658   |  0.751918403509817  |  0.745720804603674  |  0.741365190670725  |  0.729176432870938  |  0.83409511349803   |  0.870934367047043  |  0.781929625462789  |  0.786852216118889  |  0.801349964236715  |  0.810610317215054  |  0.79310253404803   |  0.792202648730367  |  0.784679485654544  |  0.764156356211848  |  0.640186795411244  |  0.707470058980595  |  0.678876726774343  |  0.637768324076329  |  0.580912172474241  | 0.299533580065695  | 0.0362462350505722 | 0.0359060360195654 | 0.0355665153515317 | 0.0352276710194901 | 0.0348895010045272 | 0.0329032932386442 |  0.0012567350034456  | 0.00114359333484212  | 0.00128349290270901  |
| 15  |  0.212193869651688   |  0.422164528332642  |  0.627169341955671  |  0.837859668653946  |  0.87352422556479   |  0.820704782473821  |  1.79693533112508   |  0.852501310618306  |  0.837959665312599  |  0.822183524763731  |  0.940822523948768  |  0.991800736132706  |  1.01522794226959   |  0.91544048508758   |  0.941491969567255  |  0.958110546088266  |  0.94954105823658   |  0.935464791236729  |  0.929106556094517  |  0.906004805233736  |  0.757801074512588  |  0.838000392733056  |  0.804185416646659  |  0.755323876548388  |  0.688068529628399  | 0.354764432585494  | 0.0429296608689297 | 0.0425267327024958 | 0.0421246079820568 | 0.0417232843068776 | 0.0413227592857784 | 0.0389703156268542 | 0.00148846376526439  | 0.00135445995889622  | 0.00152015554068163  |
| 16  |  0.242406786718193   |  0.482320941609924  |  0.71653966329168   |  0.957487144014299  |  0.994349987201864  |  0.927588809968975  |  0.971992910363318  |  1.88029572085916   |  0.932624994095769  |  0.915084622598097  |   1.0452392678578   |  1.10278884511392   |  1.13764711320185   |  1.15525084940753   |  1.08023417626027   |  1.10513929046828   |  1.11061677963145   |  1.10137413581581   |  1.08051355703546   |  1.05658298311275   |  0.885271152612735  |  0.977106241239471  |  0.938285482888756  |  0.881354521637801  |  0.802663202626527  | 0.413906564740078  | 0.0500863864120119 | 0.0496162868251107 | 0.0491471246252223 | 0.0486788970113895 | 0.048211601193803  | 0.0454669859387909 | 0.00173660284750275  | 0.00158025951073778  | 0.00177357790105551  |
| 17  |  0.240182871243715   |  0.477895978842861  |  0.709965904912858  |  0.948702858289397  |  0.985227510255058  |  0.919078820886691  |  0.963075544213196  |  0.945614108741182  |  1.84149999414994   |  0.906689350831143  |  1.03564991677653   |  1.09267151625966   |  1.12720998372293   |  1.14465221776158   |  1.07032377097348   |  1.09500039789518   |  1.10042763486419   |  1.09126978594594   |   1.0706005886223   |  1.04688956124933   |  0.87714939891904   |  0.968141963796907  |  0.929677359192529  |  0.873268700338371  |  0.795299320033623  | 0.410109256806682  | 0.0496268782797916 | 0.0491610915331372 | 0.0486962335736148 | 0.0482323016259639 |  0.04776929292597  | 0.0450498576274258 | 0.00172067071128713  | 0.00156576171706129  | 0.00175730654416509  |
| 18  |  0.271782183469522   |  0.540832745313607  |  0.803467531208225  |  1.07395928155164   |  1.11007792831509   |  1.02721146364839   |  1.07387859710272   |  1.04423697755425   |  1.02019046950976   |  1.91070476111306   |  1.14141043345737   |   1.1995282046653   |  1.24523598438383   |  1.26936527137919   |  1.32805634958021   |  1.24272130711313   |  1.26711455263427   |  1.26518949342746   |  1.25011949089346   |  1.20861638539411   |  1.01793708290226   |  1.12339407267671   |  1.07721712999349   |  1.01281877546985   |  0.922260965145154  | 0.475613882440562  | 0.0575535222878011 | 0.0570133378386847 | 0.0564742305270541 | 0.0559361971343709 | 0.055399234454907  | 0.0522454378533439 | 0.00199550452425609  | 0.00181585271941169  | 0.00203799200880401  |
| 19  |  0.300602475946448   |  0.598263334407089  |  0.888789982738558  |  1.18840187466383   |  1.22168792117974   |  1.12128348321563   |  1.16447216004152   |  1.12920562782696   |  1.10439138167824   |  1.08517394199199   |  2.13464117822183   |  1.29010368488038   |  1.33550718179812   |  1.36350349414729   |  1.44681434284062   |  1.49431333269763   |  1.41327920780033   |  1.42243695868643   |  1.41760936714279   |  1.38043404653272   |  1.15453136633639   |  1.27728803876375   |  1.22544387405263   |  1.15103279057963   |  1.04860047929701   | 0.540637213792007  | 0.0654219253944537 | 0.0648078898789101 | 0.0641950787612042 | 0.0635834883827765 | 0.0629731150996293 | 0.0593881486583924 | 0.00226831899978861  | 0.00206410618176618  |  0.0023166151410811  |
|  2  |  0.273652258887148   |  0.544633059518311  |  0.809116185463372  |  1.08190192207294   |  1.11166589256965   |  1.01955671428974   |  1.05819306958555   |  1.02588799029688   |  1.00344230956417   |  0.904886249553391  |  1.12081309328616   |   2.0643413122774   |  1.21240122621208   |  1.23799317086212   |  1.31531989785274   |   1.3700139898063   |   1.2875254155312   |  1.29677328107071   |  1.29333432896353   |  1.26019656527849   |  1.05333581102069   |  1.16558063907151   |  1.11832230999917   |   1.0503254642825   |  0.956893245986751  | 0.493344570593814  | 0.0596990937134495 | 0.0591387714122516 | 0.0585795664037779 | 0.0580214753495043 | 0.0574644949241944 | 0.0541931260941796 | 0.00206989610476763  | 0.00188354695519579  |  0.0021139675051068  |
| 20  |  0.256733916330697   |  0.51104230441626   |  0.75921611300497   |  1.01557979047912   |  1.03675002652783   |  0.939022929118602  |  0.966825358334092  |  0.936248842166872  |  0.852074921334713  |  0.821610405030754  |  0.942609848594383  |  1.06181814301638   |   1.9803730402916   |  1.11890746121298   |  1.21511881035419   |  1.27639498512683   |  1.34861727863252   |  1.24009629976239   |  1.24910584790243   |  1.22630310781183   |   1.017301127635    |  1.12878582849953   |  1.08360819562401   |  1.01663172604512   |  0.926664799074554  | 0.477633446129552  | 0.0577979075088326 | 0.0572554293148549 | 0.0567140328321314 | 0.0561737148284572 | 0.0556344720844918 | 0.0524672837520854 | 0.00200397788600432  | 0.00182356323912541  | 0.00204664578198302  |
| 21  |  0.248227779488166   |  0.494218368734223  |  0.734226003303193  |  0.982687643398007  |  0.994479034454911  |  0.883155696567892  |  0.907368134918183  |  0.846735544045006  |  0.790129655278206  |  0.775393006491093  |  0.872702204723139  |  0.92703689329313   |  1.01689274306809   |   1.9153542736887   |  1.13754644945804   |  1.20265820993786   |  1.31040849777737   |  1.34669100041271   |  1.23436161840835   |  1.22631771544052   |  1.03746925066632   |  1.13295943081614   |  1.09192804077095   |  1.02618811044321   |  0.933163800959011  | 0.481579621805752  | 0.058275429965844  | 0.0577284698532082 | 0.0571826003888529 | 0.0566378183138688 | 0.0560941203823175 | 0.0529007649511441 | 0.00202053461764335  | 0.00183862939698467  |  0.0020635550329329  |
| 22  |  0.247740481072168   |  0.493396019374998  |  0.733009653160218  |   0.9817939611424   |  0.981251566457224  |  0.854244634978202  |  0.876760757470747  |  0.786275311878566  |  0.766496818915394  |  0.756558965456113  |  0.84462045011121   |  0.856460482725332  |  0.940671337094794  |  0.990872541046555  |  1.96139382784761   |  1.15628669412462   |  1.29573257263814   |  1.34816250726081   |  1.38784532256333   |   1.2557893478117   |  1.09091964247158   |  1.20305826270504   |  1.14393680981988   |  1.08158513098675   |  0.98407201882014   | 0.507707871768901  | 0.0614371812773887 | 0.0608605456762237 | 0.0602850598967958 | 0.0597107205033827 | 0.0591375240739366 | 0.0557709121652278 | 0.00213015934252483  |  0.0019383847983737  | 0.00217551384362969  |
| 23  |  0.216927165525523   |  0.432226758418132  |  0.642141228192199  |  0.861067944812799  |  0.843674196018218  |  0.716825352225776  |  0.695610255206846  |  0.654734822364087  |  0.647905732513161  |  0.642298989917132  |  0.711876443894582  |  0.703337906783647  |  0.704083681085624  |  0.732419249914895  |  0.906887100092866  |  1.82308975918707   |  1.09321195475424   |  1.16997863357336   |  1.24009348466059   |  1.26752354823618   |  1.01124390900566   |  1.13785151927113   |   1.0956491075349   |  1.02216090329094   |  0.934121689750038  | 0.480825228903178  | 0.0581841416953897 | 0.0576380383939816 | 0.0570930240323569 | 0.0565490953567116 | 0.0560062491261919 | 0.0528178960758577 | 0.00201736945677288  | 0.00183574919004745  | 0.00206032248072257  |
| 24  |  0.193492192907198   |  0.385569347517664  |  0.572825592020731  |  0.768302509701516  |  0.749698371981323  |  0.616747317011816  |  0.59311574425243   |  0.57374314116502   |  0.569108306448091  |  0.564704120297908  |  0.624438679973295  |  0.613037186156672  |  0.609762817938952  |  0.621974156710297  |  0.766078270982995  |  0.852600174774314  |  1.83100700605279   |  1.04981189809783   |  1.11978907938031   |  1.15351134275698   |  0.914348555479648  |  1.03092842014415   |  0.993381470568937  |  0.925847679527178  |  0.846439888126328  | 0.435601982265045  | 0.0527117254573296 | 0.0522169850270957 | 0.0517232311181584 | 0.0512304607827449 | 0.0507386710848148 | 0.0478501934729921 | 0.00182762900427627  | 0.00166309074078794  | 0.00186654215036771  |
| 25  |  0.165925826746795   |  0.33086784402779   |  0.491565979529305  |  0.660452428268094  |  0.627527747278574  |  0.470962759812992  |  0.48165365507294   |  0.474157744369669  |  0.471902467756529  |  0.469117708397332  |  0.516160631110634  |  0.500300930798932  |  0.492007476935382  |  0.497052697771133  |  0.54069464832611   |  0.60224363469453   |  0.791621863699181  |  1.70473787279777   |  0.929177916732962  |  0.997955357774641  |  0.961995500948763  |  0.949059809593501  |  0.938161788176031  |  0.892132379953116  |  0.798736088424077  | 0.415590375973661  | 0.0502901425910015 | 0.0498181305943133 | 0.0493470597980173 | 0.0488769273897617 | 0.0484077305683882 | 0.0456519499577332 | 0.00174366751289344  | 0.00158668815657922  | 0.00178079298447732  |
| 26  |  0.172808437336453   |  0.344822811294809  |  0.512307030731636  |  0.689462611066773  |  0.633914938943071  |  0.479108285645414  |  0.493450793768153  |  0.487554687273473  |  0.485522230185971  |  0.482937020852494  |  0.530418382279189  |  0.511923309454059  |  0.503848240787414  |  0.507818997145943  |  0.543299289585638  |  0.572427734369471  |  0.768932368523526  |   0.8457310081337   |  1.75667381746505   |  0.988836108575665  |  1.00041561438658   |  1.17264294385693   |  1.03335791765504   |   1.0100048589901   |  0.922762833986326  | 0.475045615443243  |  0.05748475691214  | 0.0569452178794133 | 0.0564067546972005 | 0.0558693641508089 | 0.0553330430383404 | 0.0521830146163681 | 0.00199312028063746  | 0.00181368312510309  | 0.00203555700082345  |
|  3  |  0.151185191337698   |  0.301929277729937  |  0.448588806166573  |  0.604967212263329  |  0.532719818778295  |   0.4033103234474   |  0.421891249725435  |  0.418857559466621  |  0.417497963908512  |  0.415626457496146  |  0.455317172137666  |  0.436702568040918  |  0.429935661541026  |  0.432095581519658  |  0.446634997140905  |  0.460772417860325  |  0.520675183515443  |  0.633865790925671  |  0.747422847917021  |  1.64497605894068   |  0.862144054484936  |  1.07918318071632   |  1.12095503389319   |  0.971446848036996  |  0.908406264900471  | 0.462039996955376  | 0.0559109610639886 | 0.0553861933260404 | 0.0548624719843793 | 0.0543397939123231 | 0.0538181559956341 | 0.0507543678557532 | 0.00193855339036901  | 0.00176402879714773  | 0.00197982829414269  |
|  4  |  0.131049030350643   |  0.262160099158857  |  0.389518146811556  |  0.527504519834192  |  0.442316019133042  |  0.342154353033725  |  0.360152070109594  |  0.358339072613479  |  0.357338908706596  |  0.355970989575256  |  0.38917767600088   |  0.37135982051374   |  0.366574696444962  |  0.367924155990893  |  0.374894958762277  |  0.380614941224336  |  0.401516167997669  |  0.429583627766712  |  0.501236422436724  |  0.648700314125699  |  1.53055041120305   |  0.946910165209208  |   1.037148725901    |  1.07525227502152   |  0.885296222779025  | 0.481873724984365  | 0.0583110190738792 | 0.0577637249298592 | 0.0572175221001842 | 0.0566724073239547 | 0.0561283773532501 | 0.0529330717233137 | 0.00202176856863845  | 0.00183975225751585  | 0.00206481525671926  |
|44100|  0.101802251583302   |   0.2041615762505   |  0.303362144064407  |  0.413342771816601  |  0.284622594699509  |  0.251867108036271  |  0.266099348597074  |  0.265219069168578  |  0.264658806354956  |  0.264191822310273  |  0.286782552531528  |  0.269217726827595  |  0.269859942524894  |  0.270539438020624  |  0.27319781366125   |  0.275077767377702  |  0.278474262223577  |  0.284657241284663  |  0.300051918238832  |  0.331358253707055  |  0.518530079410501  |  1.55312344110517   |  0.847084571247971  |   0.9481498344351   |  0.953967515708387  | 0.467512216045307  | 0.0565731483864864 | 0.0560421655068788 | 0.0555122414166623 | 0.0549833729521235 | 0.054455556962141  | 0.0513554825265779 | 0.00196151285045803  | 0.00178492125694028  | 0.00200327659787697  |
|44102|  0.0786003663073115  |  0.157742684717276  |  0.234392686933455  |  0.319920514187864  |  0.206791220744278  |  0.191402811111519  |  0.202446561435298  |  0.201882974907995  |  0.201498026768017  |  0.201268386510349  |  0.218006017990471  |  0.203626068635594  |  0.205080035469048  |  0.205523611078922  |  0.206970236850932  |  0.207858324019256  |  0.207658702953865  |  0.208999408566081  |  0.212035521576962  |  0.217910571996919  |  0.253000902868432  |  0.565820701995427  |  1.47613166218156   |  0.756861642484798  |  0.795063546650924  | 0.381440179941917  | 0.0461576642487795 | 0.0457244387667657 | 0.0452920771441377 | 0.0448605767996425 | 0.0444299351623004 | 0.0419006045695359 | 0.00160038559198758  | 0.00145630565803969  | 0.00163446036219419  |
|44103|  0.0747202542534306  |  0.151085686209771  |  0.224541552072727  |  0.312040927748068  |  0.197664444987144  |  0.184190895856601  |  0.194845757487178  |  0.194310988156741  |  0.193941174360235  |  0.193733758957363  |  0.209995908441732  |  0.195840239899937  |  0.197383709387289  |  0.197806084595572  |  0.199134453782789  |  0.19992259887598   |  0.199321087591085  |  0.200139037105878  |  0.201836582360058  |  0.204952918088907  |  0.223545284511533  |  0.45757281726198   |  0.61787585399038   |  1.52472063910656   |  0.792422155343949  | 0.569519311016879  | 0.0689169167891968 | 0.0682700780684594 | 0.0676245291557394 | 0.0669802661970289 | 0.066337285353659  | 0.0625608016682105 |  0.0023894978757846  | 0.00217437553412187  | 0.00244037410925871  |
|44104|  0.0549174321105287  |  0.111348367233971  |  0.165495331393948  |  0.231473232529146  |  0.14394441384678   |  0.135569788984884  |  0.143447866589725  |  0.143069512622344  |  0.142802636343115  |  0.142669267562676  |  0.154624093972315  |  0.143993487969017  |  0.145288480973515  |  0.145589016539356  |  0.146477959618935  |  0.146972753534402  |  0.146073945362429  |  0.146130900617773  |  0.145972642961014  |  0.145353633748688  |  0.14161792626782   |  0.236913900138336  |  0.354476928856865  |  0.53067709278976   |  1.39909427099508   | 0.474309162195365  | 0.057395639499927  | 0.0568569369032395 | 0.0563193084891974 | 0.0557827510480917 | 0.0552472613829881 | 0.0521021163839691 | 0.00199003038809585  | 0.00181087141021786  | 0.00203240131952514  |
|44105|  0.0236726533638111  | 0.0528419473958301  | 0.0787105155710479  |  0.133703058223812  | 0.0738960374559481  |  0.069838323071707  |  0.073882321455352  | 0.0736595119014691  | 0.0735013996827904  | 0.0734189535785694  | 0.0804837676639267  | 0.0742446374496168  | 0.0749744240992277  | 0.0751517195134499  | 0.0756658181928333  | 0.0759463876934597  | 0.0753283469309581  | 0.0752648369364433  | 0.0749187015795843  | 0.0740286163259196  | 0.0686848084891527  |  0.102858361773066  |  0.135509890729056  |  0.209725983382074  |  0.384892545448841  |  1.09147594591117  | 0.132078325504823  | 0.130838667970984  | 0.129601482336515  | 0.128366761215261  | 0.127134497250468  | 0.119896918079653  | 0.00457943989566919  | 0.00416716087929357  | 0.00467694349911398  |
|  5  |  0.00428206805760895 | 0.00143066948454697 | 0.00248609622013471 |  0.0143117389077685 | 0.00399723884855405 | 0.00368776360460498 |  0.0038837959153822 | 0.00384817138869325 | 0.00382329399451112 | 0.00380498715486426 | 0.00486317124205566 | 0.00399893037788482 | 0.00405494366918949 | 0.00408316199355551 | 0.0041691900054045  | 0.00421928484955422 | 0.00415518112338903 | 0.00418380759293969 | 0.00422943429719749 | 0.00429682184501568 | 0.00469640136199786 | 0.00965375227436077 | 0.0153530270373853  | 0.0280591806267465  |  0.0576326391564692 | 0.177464596687384  | 0.780529204483932  | 0.217058498282155  |  0.2156480201853   | 0.214240351805769  | 0.212835484756346  | 0.204584138628267  | 0.000604139081936176 | 0.00692343936454599  | 0.00777620026969846  | 
|  6  |  0.0259402288354608  |  0.0453067426790929 |  0.067079346258279  |  0.0390920098750296 |  0.0436167929042948 |  0.0416693653940306 |  0.0441500318608842 |  0.0441068690385687 |  0.0440743149903576 |  0.0440784347669058 |   0.04574864583306  |  0.0439952376544178 |  0.0443781531355459 |  0.0444131175895012 |  0.0444943156685055 |  0.0445240818635329 |  0.0442366504206094 |  0.0440375653817638 |  0.0434841380133667 |  0.0423015074177095 |  0.0352251014092748 |  0.0379153673265637 |  0.0350318480649831 |  0.0298833037282514 |  0.0200879211521154 | 0.0224788345113363 | 0.384172117569439  | 0.615255016128572  | 0.381328671975407  |  0.37991119735408  |  0.37849654357777  | 0.370187716087991  |  0.0064102855341364  |  0.0042413464396756  | 0.00475875747304311  | 
|  7  |  0.0232078133677134  |  0.0339272275917191 |  0.0501135004887265 |  0.0443092196934612 |  0.0375804954755689 |  0.0357951203347312 |  0.0379144448526338 |  0.0378627346044663 |  0.0378248250112203 |  0.0378194279746241 |  0.0396588983260008 |  0.0378449115375506 |  0.0381783528972693 |  0.0382198900092202 |  0.0383276188469578 |  0.0383771160743835 |  0.0381282932410054 |  0.0379960424275712 |  0.0376097319839136 |  0.0367676539958474 |  0.0317270862523631 |  0.0387079346991589 |  0.0421418709491858 |  0.0507811599939226 |  0.0725698614086085 |  0.158648479992167 | 0.264214527838954  | 0.263097441769912  | 0.735026389890218  |  0.26086994544499  |  0.25975952190391  | 0.253237560277727  | 0.00222942561270641  | 0.000425315374909903 | 0.00944154681479051  | 
|  8  |  0.0182907332924413  |  0.0351597425158603 |  0.052033993145768  |  0.0444018564173223 |  0.0373303300991636 |  0.0355389861905309 |  0.0376354365783722 |  0.0375730140647305 |  0.037527608260277  |  0.0375159471649261 |  0.0396677710847952 |  0.0376088431525067 |  0.0379509426699467 |  0.0380009704744415 |  0.0381343985393365 |  0.0381988491664444 |  0.0379289998237746 |  0.0378035261819059 |  0.0374261535221454 |  0.0365943930720028 |  0.0316144366657436 |  0.0387208637274869 |  0.0423406202037888 |  0.0513852580456434 |  0.0741022669535889 |  0.163962325837437 | 0.274129442680653  | 0.273008701093938  | 0.271890194286061  | 0.725242020675586  |  0.26965985832289  | 0.263116554432538  | 0.00258327120194925  | 0.00871848943562744  | 0.000834110680426044 | 
|  9  |   1.55596163072858   |   2.63641405458023  |   3.90003008467143  |   2.91386832729571  |   2.72330930990013  |   2.59663823089974  |   2.75054926392216  |   2.74698455270021  |   2.74435624445472  |   2.7440884674722   |   2.87277297556912  |   2.74457794830801  |   2.76887083104418  |   2.77173907981294  |   2.77902135392293  |   2.78224737634749  |   2.76376852139839  |   2.75318156846493  |   2.72272190511781  |   2.65671885877008  |   2.26167492252177  |   2.63725825108415  |   2.72052412446678  |   2.98081243909448  |   3.71421620035713  |   6.5182699867831  |  9.95531339228791  |  9.95082299332193  |  9.94634154829207  |  9.94186903044355  |  8.94238053750617  |  8.95198482308775  |  0.348279118154781   |  0.310394862809376   |  0.349153967999911   | 
|  A  |   1.60140161530726   |   2.70906326046144  |   4.00731495999829  |   2.98835193545263  |   2.79724629228759  |   2.66719361217727  |   2.82529735381085  |   2.82165026130486  |   2.81896055812585  |   2.81869398995385  |   2.95046005061251  |   2.81910531837086  |   2.84404796494854  |   2.84698270960749  |   2.8544270390703   |   2.85771920366709  |   2.83875653496251  |   2.82786162138841  |   2.79653322257733  |   2.72866253609162  |   2.32244209786277  |   2.70619070500343  |   2.78914593246354  |   3.0508189285373   |   3.79099563674582  |  6.61782698097902  |  10.082765652096   |  10.0792551111839  |  10.0757515703534  |  10.0722550086879  |  10.0687654053541  |  9.04826956913328  |  0.352774173894877   |   0.32248044240785   |  0.362759028653842   | 
|  B  |   1.60140161530726   |   2.70906326046144  |   4.00731495999829  |   2.98835193545263  |   2.79724629228759  |   2.66719361217727  |   2.82529735381085  |   2.82165026130486  |   2.81896055812585  |   2.81869398995385  |   2.95046005061251  |   2.81910531837086  |   2.84404796494854  |   2.84698270960749  |   2.8544270390703   |   2.85771920366709  |   2.83875653496251  |   2.82786162138841  |   2.79653322257733  |   2.72866253609162  |   2.32244209786277  |   2.70619070500343  |   2.78914593246354  |   3.0508189285373   |   3.79099563674582  |  6.61782698097902  |  10.082765652096   |  10.0792551111839  |  10.0757515703534  |  10.0722550086879  |  10.0687654053541  |  10.0482695691333  |  0.647225826105123   |   0.32248044240785   |  0.362759028653842   | 
|  C  |   1.60452460094489   |   2.71527538820124  |   4.03596115725938  |   3.00067535762834  |   2.81018791385647  |   2.67949913316264  |   2.83830804001222  |   2.83460865924746  |   2.83188160715427  |   2.83159380876738  |   2.96501623020695  |   2.8322212304407   |   2.85731703787758  |   2.86029347016249  |   2.86785602109649  |   2.87121134458886  |   2.85208052789896  |   2.84114554398891  |   2.80967031258351  |   2.74145442249456  |   2.33316438341254  |   2.7180363086118   |   2.80051312961269  |   3.06149845024229  |   3.80072262147018  |  6.62284259741394  |  10.0821587177676  |  10.078653873405   |  10.075156017765   |  10.0716651299648  |  10.0681811892051  |  10.0477186115468  |   0.35275313017505   |  0.677538706782447   |  0.362737536879545   | 
|  D  |   0.880295136150399  |   2.55484170189327  |   3.8073308206926   |   2.6825243723863   |   2.4742130853796   |   2.35718105609542  |   2.49602827306575  |   2.49153917629882  |   2.48827467381092  |   2.48731946279743  |   2.64096633220124  |   2.49540023294212  |   2.51871053196511  |   2.52230804871015  |   2.53190917764079  |   2.53656532191272  |   2.51718688061478  |   2.50820823152121  |   2.48118438411519  |   2.4216054518236   |   2.06488244095408  |   2.42177546089277  |   2.51619901771912  |   2.79436480065111  |   3.55743177781448  |  6.49738783199494  |  10.0973398634495  |  10.0936925322591  |  10.0900524739126  |  10.0864196666783  |  10.0827940889112  |  10.0614996204536  |  0.353279493179214   |  0.322940268675082   |  0.636724893005641   | 
        MATRIX
        lines = matrix_text.split(/\n/)
        lines.shift
        lines.map do |line|
          row = line.scan(/[A-Z\d\.]+/)
          row.shift
          row.map(&:to_f)
        end
      end
    end
  end
end
