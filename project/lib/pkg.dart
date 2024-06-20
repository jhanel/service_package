library service_package; //

// Annabel's code
 class ServiceData{ // service data class
    double? rate; // ? means null property
    String? unit;
    String? mtl;

    ServiceData( // service data constructor
        {
          this.rate, 
          this.unit,
          this.mtl 
        }
      );

      
      
      ServiceData.fromJson(Map<String,dynamic> json) //convert json file into data
      {
        rate = json['rate']; //assigns data to variables
        unit = json['unit'];
        mtl = json['mtl'];
      }
  }


//code from service.dart

/*class ServicesScreen extends StatefulWidget {
  const ServicesScreen({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final HomeCallback callback;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late Size size;
  bool? newOrder;
  String? type;

  String selectedUnit = 'mm';
  String selectedMtl = 'Aluminum';

  TextEditingController qtyTextControllers = TextEditingController();

  List<DropdownMenuItem<String>> units = [
    const DropdownMenuItem(value: 'mm', child: SizedBox(child:Text('mm'))),
    const DropdownMenuItem(value: 'cm', child: SizedBox(child:Text('cm'))),
    const DropdownMenuItem(value: 'inch', child: SizedBox(child:Text('inch'))),
  ];
  List<DropdownMenuItem<String>> materials = [
    const DropdownMenuItem(
      value: 'Aluminum', 
      child: SizedBox(
        child: Text('Alumnium \n Description of material')
      )
    ),
    const DropdownMenuItem(
      value: 'Steel',
      child: SizedBox(
        child: Text('Steel \n Description of material')
      )
    ),
    const DropdownMenuItem(
      value: 'Brass',
      child: SizedBox(
        child: Text('Brass \n Description of material')
      )
    ),
  ];
  static List<String> types = ['thermoform', 'mill', 'printer_3d', 'lathe',];
  static List<List<String>> acceptedExt = [['f3d', 'obj', 'stl', 'stp', 'step'], ['f3d', 'stp', 'step']];
  static dynamic rates = {'aluminum': [0.01, 0.05, 0.10], 'steel': [0.01, 0.05, 0.10], 'brass': [0.01, 0.05, 0.10]};

  Widget sopCard(String title){
    double width = (CSS.responsive()-30)/2;
    try{
    String img = Emblems.getEmblemLocation(title, 'md');
    return InkWell(
      onTap: (){
        setState(() {
          type = title;
        });
      },
      child: Container(
        height: width,
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        padding: const EdgeInsets.all(5),
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: lightBlue,width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 5,
            offset: const Offset(3,3)
          )]
        ),
        child: Column(
          children: [
            SizedBox(
              height: 22,
              child:Text(
                title.replaceAll('_', ' ').toUpperCase(),
                style: Theme.of(context).primaryTextTheme.headlineSmall,
              )
            ),
            Image.asset(
              img,
              fit: BoxFit.fitWidth,
              width: width-38,
              height: width-38,
            )
          ],
        )
      )
    );
    }
    catch(e){
      print('sopCard -> Exception: $e');
      return Container(
        color: Theme.of(context).cardColor,
        height: width,
        width: width                                                                                                          
      );
    }
  }

  Widget sopCards(){
    List<Widget> widgets = [];

    for(int i = 0; i < types.length;i++){
      print('types: ${types[i]}');
      widgets.add(sopCard(types[i]));
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: widgets
    );
  }

  Widget createNewOrder(){
    return type==null?Expanded(
        child: Container(
          width: deviceWidth,
          color: Theme.of(context).canvasColor,
          child: ListView(
            padding: const EdgeInsets.all(0),
            children:[
              sopCards()
            ]
          )
        )
      ):Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            width: deviceWidth - 40,
            height: 100,
            child: Column(
              children: [
                LSIWidgets.squareButton(
                  text: 'upload',
                  onTap: () {
                    
                  },
                  textColor: Theme.of(context).indicatorColor,
                  buttonColor: Theme.of(context).primaryTextTheme.bodyMedium!.color!,
                  height: 45,
                  radius: 45 / 2,
                  width: CSS.responsive() / 2,
                ),
                Text(
                  'Accepted extensions are ${(type=='mill'||type=='lathe')?acceptedExt[1]:acceptedExt[0]}',
                  style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(color: darkGrey),
                )
              ]
            )
          ),
          SizedBox(
            width: deviceWidth - 40,
            height: 500,
            child: Row(
              children: [
                Container(
                  width: CSS.responsive(),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LSIWidgets.dropDown(
                        itemVal: units,
                        value: selectedUnit,
                        width: 200,
                        height: 40,
                        color: Theme.of(context).canvasColor,
                        style: Theme.of(context).primaryTextTheme.labelLarge!,
                        onchange: (val) {
                          selectedUnit = val;

                          setState(() { });
                        }
                      ),
                      LSIWidgets.dropDown(
                        itemVal: materials,
                        value: selectedMtl,
                        width: 200,
                        height: 40,
                        color: Theme.of(context).canvasColor,
                        style: Theme.of(context).primaryTextTheme.labelLarge!,
                        onchange: (val) {
                          selectedUnit = val;

                          setState(() { });
                        }
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Qty:',
                            style: Theme.of(context).primaryTextTheme.headlineMedium,
                          ),
                          EnterTextFormField(
                            width: 50,
                            height: 40,
                            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
                            color: Theme.of(context).canvasColor,
                            maxLines: 1,
                            label: '',
                            keyboardType: TextInputType.number,
                            controller: qtyTextControllers,
                            onEditingComplete: () {},
                            onSubmitted: (val) {},
                            onTap: () { },
                          ),
                        ]
                      )
                    ],
                  )
                ),
                Container(
                  width: CSS.responsive(),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 5.0, color: darkGrey),
                          )
                        ),
                        child: Text(
                          'Quote',
                          style: Theme.of(context).primaryTextTheme.headlineMedium
                        ),
                      ),
                      Text(
                        type!,
                        //style: ..
                      ),
                      Text(
                        '$selectedMtl USD${rates[selectedMtl][selectedUnit=='mm'?0:selectedUnit=='cm'?1:2]} / $selectedUnit',
                        //style: ..
                      ),
                      Text(
                        type!, //volume
                        //style: ..
                      ),
                      Text(
                        type!, //qty
                        //style: ..
                      ),
                    ]
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget trackOrder(){
    return Container(
      color: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    //size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: newOrder==null?Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Is This A New Order?',
                style: Theme.of(context).primaryTextTheme.displayMedium,
              ),
              LSIWidgets.squareButton(
                text: 'yes',
                onTap: () {
                  setState(() {
                    newOrder = true;
                  });
                },
                textColor: Theme.of(context).indicatorColor,
                buttonColor: Theme.of(context).primaryTextTheme.bodyMedium!.color!,
                height: 45,
                radius: 45 / 2,
                width: CSS.responsive() / 3,
                margin: const EdgeInsets.all(5)
              ),
              LSIWidgets.squareButton(
                text: 'no',
                onTap: () {
                  setState(() {
                    newOrder = false;
                  });
                },
                buttonColor: Colors.transparent,
                borderColor: Theme.of(context).primaryTextTheme.bodyMedium!.color,
                height: 45,
                radius: 45 / 2,
                width: CSS.responsive() / 3,
                margin: const EdgeInsets.all(5)
              ),
            ],
          )
      )):newOrder!?createNewOrder():trackOrder(),
    );
  }
}*/