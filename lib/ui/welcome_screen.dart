import 'package:flutter/material.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/ui/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  City? selectedCity;

  @override
  Widget build(BuildContext context) {
    List<City> cities = City.citiesList.where((city) => !city.isDefault).toList();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 136, 71, 148),
        title: Text(
          selectedCity != null ? selectedCity!.city : '',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cities.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * .08,
            width: size.width,
            decoration: BoxDecoration(
              border: selectedCity == cities[index]
                  ? Border.all(
                      color: const Color.fromARGB(255, 136, 71, 148).withOpacity(.6),
                      width: 2,
                    )
                  : Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 136, 71, 148).withOpacity(.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedCity == cities[index]) {
                        selectedCity = null;
                      } else {
                        selectedCity = cities[index];
                      }
                      cities.forEach((city) => city.isSelected = false);
                      if (selectedCity != null) {
                        selectedCity!.isSelected = true;
                      }
                    });
                  },
                  child: Image.asset(
                    selectedCity == cities[index] ? 'assets/checked.png' : 'assets/unchecked.png',
                    width: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  cities[index].city,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: selectedCity == cities[index]
                        ? const Color.fromARGB(255, 136, 71, 148)
                        : Colors.black54,
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 136, 71, 148),
        child: const Icon(Icons.pin_drop),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(city: selectedCity)),
          );
        },
      ),
    );
  }
}
