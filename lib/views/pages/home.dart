part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool isProvinceOriginSelected = false;
  bool isProvinceDestinationSelected = false;
  bool isCityOriginSelected = false;
  bool isCityDestinationSelected = false;

  var selectedService = 'jne';
  var itemWeight = 0;
  List<Costs> costLists = [];

  dynamic provinceData;
  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  dynamic cityDataDestination;
  dynamic cityIdDestination;
  dynamic selectedCityDestination;

  Future<List<Province>> getProvinces() async {
    dynamic prov;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        prov = value;
        isLoading = false;
      });
    });

    return prov;
  }

  Future<List<City>> getCities(var provId) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  Future<dynamic> getCosts(
      var courier, var origin, var destination, var weight) async {
    await MasterDataService.getCosts(
            cityIdOrigin, cityIdDestination, itemWeight, selectedService)
        .then((value) {
      setState(() {
        costLists = value;
      });
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Raja Ongkir",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 120,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text("Service"),
                                items: ["jne", "pos", "tiki"].map((service) {
                                  return DropdownMenuItem<String>(
                                    value: service,
                                    child: Text(service),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedService = newValue as String;
                                  });
                                },
                                value: selectedService,
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 70),
                        Column(
                          children: [
                            Container(
                                width: 150,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Berat Barang (gram)",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      itemWeight = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Origin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: FutureBuilder<List<Province>>(
                                    future: provinceData,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                            isExpanded: true,
                                            value: selectedProvinceOrigin,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 4,
                                            style:
                                                TextStyle(color: Colors.black),
                                            hint: selectedProvinceOrigin == null
                                                ? Text("Province")
                                                : Text(selectedProvinceOrigin
                                                    .province),
                                            items: snapshot.data?.map<
                                                    DropdownMenuItem<Province>>(
                                                (Province value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.province.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedProvinceOrigin =
                                                    newValue;
                                                isProvinceOriginSelected = true;
                                              });
                                              selectedCityOrigin = null;
                                              cityDataOrigin = getCities(
                                                  selectedProvinceOrigin
                                                      .provinceId);
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingDD();
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 70),
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: FutureBuilder<List<City>>(
                                    future: cityDataOrigin,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                            isExpanded: true,
                                            value: selectedCityOrigin,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 4,
                                            style:
                                                TextStyle(color: Colors.black),
                                            hint: selectedCityOrigin == null
                                                ? Text("Select City")
                                                : Text(selectedCityOrigin
                                                    .cityName),
                                            items: snapshot.data!
                                                .map<DropdownMenuItem<City>>(
                                                    (City value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCityOrigin = newValue;
                                                cityIdOrigin =
                                                    selectedCityOrigin.cityId;
                                                isCityOriginSelected = true;
                                              });
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingDD();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Destination",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                    width: 150,
                                    child: FutureBuilder<List<Province>>(
                                      future: provinceData,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return DropdownButton(
                                              isExpanded: true,
                                              value:
                                                  selectedProvinceDestination,
                                              icon: Icon(Icons.arrow_drop_down),
                                              iconSize: 30,
                                              elevation: 4,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              hint: selectedProvinceDestination ==
                                                      null
                                                  ? Text("Select Province")
                                                  : Text(
                                                      selectedProvinceDestination
                                                          .province),
                                              items: snapshot.data!.map<
                                                      DropdownMenuItem<
                                                          Province>>(
                                                  (Province value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value.province
                                                      .toString()),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedProvinceDestination =
                                                      newValue;
                                                  isProvinceDestinationSelected =
                                                      true;
                                                });
                                                selectedCityDestination = null;
                                                cityDataDestination = getCities(
                                                    selectedProvinceDestination
                                                        .provinceId);
                                              });
                                        } else if (snapshot.hasError) {
                                          return Text("Tidak ada data");
                                        }
                                        return UiLoading.loadingDD();
                                      },
                                    ))
                              ],
                            ),
                            SizedBox(width: 70),
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: FutureBuilder<List<City>>(
                                    future: cityDataDestination,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                            isExpanded: true,
                                            value: selectedCityDestination,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 4,
                                            style:
                                                TextStyle(color: Colors.black),
                                            hint: selectedCityDestination ==
                                                    null
                                                ? Text("Select City")
                                                : Text(selectedCityDestination
                                                    .cityName),
                                            items: snapshot.data!
                                                .map<DropdownMenuItem<City>>(
                                                    (City value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCityDestination =
                                                    newValue;
                                                cityIdDestination =
                                                    selectedCityDestination
                                                        .cityId;
                                                isCityDestinationSelected =
                                                    true;
                                              });
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingDD();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                    child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if(cityIdDestination == null && cityIdOrigin == null && itemWeight < 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Data tidak boleh kosong"),
                        ),
                      );
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      setState(() async {
                        costLists = await getCosts(selectedService, cityIdOrigin, cityIdDestination, itemWeight);
                      });
                    }
                  },
                  child: Text("Cek Ongkir"),
                )),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: costLists.isEmpty || costLists[0].cost.isEmpty
                      ? const Align(
                          alignment: Alignment.topCenter,
                          child: Text("Empty Data"))
                      : ListView.builder(
                          itemCount: costLists.length,
                          itemBuilder: (context, index) {
                            return LazyLoadingList(
                              initialSizeOfItems: 10,
                              loadMore: () {},
                              child: CardOngkir(costLists[index]),
                              index: index,
                              hasMore: true,
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container(),
        ],
      ),
    );
  }
}
