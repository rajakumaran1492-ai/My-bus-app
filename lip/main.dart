import 'package:flutter/material.dart';

void main() => runApp(const MyBusApp());

const navy = Color(0xFF102A56);
const blue = Color(0xFF1769E0);
const paleBlue = Color(0xFFEAF2FF);
const canvas = Color(0xFFF5F7FB);
const green = Color(0xFF159B72);

class MyBusApp extends StatelessWidget {
  const MyBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY BUS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: navy,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: navy, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: canvas,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 15),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE9EDF4)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class BusTrip {
  final String operatorName, from, to, departure, arrival, busType;
  final int fare, availableSeats;
  final double rating;
  const BusTrip(this.operatorName, this.from, this.to, this.departure,
      this.arrival, this.fare, this.rating,
      {this.busType = 'AC Sleeper', this.availableSeats = 18});
}

const trips = [
  BusTrip('Sri Venkateswara Travels', 'Chennai', 'Coimbatore',
      '10:00 PM', '06:00 AM', 600, 4.5, availableSeats: 12),
  BusTrip('Royal Express', 'Chennai', 'Coimbatore',
      '09:30 PM', '05:30 AM', 550, 4.3, busType: 'Non-AC Sleeper'),
  BusTrip('Dream Bus', 'Chennai', 'Coimbatore',
      '11:00 PM', '07:00 AM', 650, 4.6, availableSeats: 8),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool tamil = false;
  String from = 'Chennai';
  String to = 'Coimbatore';
  DateTime date = DateTime.now().add(const Duration(days: 1));
  int tab = 0;

  String tr(String en, String ta) => tamil ? ta : en;

  Future<void> chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => date = picked);
  }

  Future<void> editCity(bool isFrom) async {
    final controller = TextEditingController(text: isFrom ? from : to);
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isFrom ? tr('Departure city', 'புறப்படும் ஊர்')
            : tr('Destination city', 'சேரும் ஊர்')),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: tr('Enter city name', 'ஊர் பெயரை உள்ளிடவும்')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(tr('Cancel', 'ரத்து')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(tr('Save', 'சேமி')),
          ),
        ],
      ),
    );
    if (value != null && value.isNotEmpty) {
      setState(() { if (isFrom) { from = value; } else { to = value; } });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: blue, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.directions_bus_rounded,
                color: Colors.white, size: 23),
          ),
          const SizedBox(width: 10),
          const Text('MY BUS', style: TextStyle(
            color: navy, fontSize: 21, fontWeight: FontWeight.w900)),
        ]),
        actions: [
          TextButton(
            onPressed: () => setState(() => tamil = !tamil),
            child: Text(tamil ? 'EN' : 'தமிழ்',
              style: const TextStyle(color: blue, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: tab == 0 ? _homeBody() : _simpleTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        backgroundColor: Colors.white,
        indicatorColor: paleBlue,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded), label: tr('Home', 'முகப்பு')),
          NavigationDestination(icon: const Icon(Icons.confirmation_number_outlined),
              selectedIcon: const Icon(Icons.confirmation_number), label: tr('Bookings', 'முன்பதிவுகள்')),
          NavigationDestination(icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person), label: tr('Profile', 'சுயவிவரம்')),
        ],
      ),
    );
  }

  Widget _homeBody() => ListView(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
    children: [
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [navy, blue],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(
            color: blue.withOpacity(.20), blurRadius: 22, offset: const Offset(0, 10))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(30)),
            child: Text(tr('TRAVEL MADE SIMPLE', 'உங்கள் பயணம் இனிதாக'),
              style: const TextStyle(color: Colors.white, fontSize: 10,
                letterSpacing: 1.2, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 15),
          Text(tr('Where would you\nlike to go?', 'எங்கே பயணம்\nசெய்ய விரும்புகிறீர்கள்?'),
            style: const TextStyle(color: Colors.white, fontSize: 27,
              height: 1.15, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(tr('Find and book your bus journey with ease.',
              'உங்கள் பேருந்துப் பயணத்தை எளிதாகத் தேடிப் பதிவு செய்யுங்கள்.'),
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 14),
          const Align(alignment: Alignment.centerRight,
            child: Icon(Icons.directions_bus_filled_rounded,
              color: Colors.white24, size: 54)),
        ]),
      ),
      const SizedBox(height: 20),
      Card(child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr('BOOK YOUR TICKET', 'டிக்கெட் முன்பதிவு'),
            style: const TextStyle(color: navy, fontWeight: FontWeight.w900,
              fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _cityField(
              tr('FROM', 'புறப்படும் இடம்'), from, Icons.trip_origin,
              () => editCity(true))),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => setState(() { final old = from; from = to; to = old; }),
              borderRadius: BorderRadius.circular(13),
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: paleBlue, borderRadius: BorderRadius.circular(13)),
                child: const Icon(Icons.swap_horiz_rounded, color: blue)),
            ),
            const SizedBox(width: 10),
            Expanded(child: _cityField(
              tr('TO', 'சேரும் இடம்'), to, Icons.location_on_outlined,
              () => editCity(false))),
          ]),
          const SizedBox(height: 13),
          InkWell(
            onTap: chooseDate,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: canvas, borderRadius: BorderRadius.circular(15)),
              child: Row(children: [
                const Icon(Icons.calendar_month_rounded, color: blue),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(tr('JOURNEY DATE', 'பயணத் தேதி'),
                      style: const TextStyle(fontSize: 10, color: Colors.blueGrey,
                        fontWeight: FontWeight.w800, letterSpacing: .8)),
                    const SizedBox(height: 3),
                    Text('${date.day.toString().padLeft(2, '0')}/'
                        '${date.month.toString().padLeft(2, '0')}/${date.year}',
                      style: const TextStyle(color: navy, fontWeight: FontWeight.w800)),
                  ])),
                const Icon(Icons.edit_calendar_outlined, color: blue),
              ]),
            ),
          ),
          const SizedBox(height: 17),
          SizedBox(width: double.infinity, child: FilledButton.icon(
            onPressed: () {
              if (from.toLowerCase() == to.toLowerCase()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(tr('Choose two different cities.',
                    'வெவ்வேறு இரண்டு ஊர்களைத் தேர்வு செய்யுங்கள்.'))));
                return;
              }
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => BusListScreen(tamil: tamil, from: from, to: to)));
            },
            icon: const Icon(Icons.search_rounded),
            label: Text(tr('Search Buses', 'பேருந்துகளைத் தேடுங்கள்')),
          )),
        ]),
      )),
      const SizedBox(height: 22),
      Row(children: [
        Expanded(child: Text(tr('Why choose MY BUS?', 'ஏன் MY BUS?'),
          style: const TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w900))),
        const Icon(Icons.verified_rounded, color: green),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        _benefit(Icons.event_seat_rounded, tr('Easy seats', 'எளிய இருக்கைத் தேர்வு')),
        const SizedBox(width: 9),
        _benefit(Icons.payments_outlined, tr('Clear fares', 'தெளிவான கட்டணம்')),
        const SizedBox(width: 9),
        _benefit(Icons.support_agent_rounded, tr('Support', 'உதவி')),
      ]),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF7F2), borderRadius: BorderRadius.circular(18)),
        child: Row(children: [
          const Icon(Icons.lock_outline_rounded, color: green, size: 25),
          const SizedBox(width: 12),
          Expanded(child: Text(
            tr('Simple booking experience, with your journey details in one place.',
              'உங்கள் பயண விவரங்கள் அனைத்தும் ஒரே இடத்தில் எளிய முன்பதிவு அனுபவம்.'),
            style: const TextStyle(color: Color(0xFF24634F), fontSize: 12,
              fontWeight: FontWeight.w600))),
        ]),
      ),
    ],
  );

  Widget _cityField(String label, String city, IconData icon, VoidCallback onTap) =>
    InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        constraints: const BoxConstraints(minHeight: 82),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: canvas, borderRadius: BorderRadius.circular(15)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 15, color: blue),
            const SizedBox(width: 5),
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9, color: Colors.blueGrey,
                fontWeight: FontWeight.w900, letterSpacing: .5))),
          ]),
          const SizedBox(height: 8),
          Text(city, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.w900)),
        ]),
      ),
    );

  Widget _benefit(IconData icon, String label) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
    decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFE9EDF4))),
    child: Column(children: [
      Icon(icon, color: blue, size: 23),
      const SizedBox(height: 7),
      Text(label, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, color: navy, fontWeight: FontWeight.w700)),
    ]),
  ));

  Widget _simpleTab() => Center(child: Padding(
    padding: const EdgeInsets.all(28),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(tab == 1 ? Icons.confirmation_number_outlined : Icons.account_circle_outlined,
        size: 56, color: blue),
      const SizedBox(height: 12),
      Text(tab == 1 ? tr('Your bookings will appear here',
        'உங்கள் முன்பதிவுகள் இங்கே தோன்றும்') : tr('Profile',
        'சுயவிவரம்'),
        style: const TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text(tr('This section will be connected when the backend is added.',
        'Backend இணைக்கப்பட்டதும் இந்தப் பகுதி செயல்படும்.'),
        textAlign: TextAlign.center, style: const TextStyle(color: Colors.blueGrey)),
    ]),
  ));
}

class BusListScreen extends StatelessWidget {
  final bool tamil;
  final String from, to;
  const BusListScreen({super.key, required this.tamil, required this.from, required this.to});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(tamil ? 'கிடைக்கும் பேருந்துகள்' : 'Available Buses')),
    body: ListView(
      padding: const EdgeInsets.all(17),
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: paleBlue, borderRadius: BorderRadius.circular(17)),
          child: Row(children: [
            const Icon(Icons.route_rounded, color: blue),
            const SizedBox(width: 10),
            Expanded(child: Text('$from  →  $to',
              style: const TextStyle(color: navy, fontWeight: FontWeight.w900))),
            Text('${trips.length} ${tamil ? 'பேருந்துகள்' : 'buses'}',
              style: const TextStyle(color: blue, fontSize: 11, fontWeight: FontWeight.w800)),
          ]),
        ),
        const SizedBox(height: 15),
        ...trips.map((bus) => Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 46, height: 46,
                  decoration: BoxDecoration(color: paleBlue,
                    borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.directions_bus_rounded, color: blue, size: 27)),
                const SizedBox(width: 11),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(bus.operatorName, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: navy, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(bus.busType, style: const TextStyle(color: Colors.blueGrey, fontSize: 11)),
                ])),
                const Icon(Icons.star_rounded, color: Colors.orange, size: 18),
                Text(bus.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 17),
              Row(children: [
                _timeBlock(bus.departure, from, true),
                const Expanded(child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Column(children: [
                    Text('8 hrs', style: TextStyle(color: Colors.blueGrey, fontSize: 10)),
                    Divider(color: blue, thickness: 1),
                    Icon(Icons.arrow_forward_rounded, color: blue, size: 17),
                  ]),
                )),
                _timeBlock(bus.arrival, to, false),
              ]),
              const Divider(height: 25),
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tamil ? 'ஒரு இருக்கைக்கான விலை' : 'FARE PER SEAT',
                    style: const TextStyle(color: Colors.blueGrey, fontSize: 9,
                      fontWeight: FontWeight.w800, letterSpacing: .5)),
                  Text('₹${bus.fare}', style: const TextStyle(
                    color: navy, fontSize: 23, fontWeight: FontWeight.w900)),
                  Text('${bus.availableSeats} ${tamil ? 'இருக்கைகள் உள்ளன' : 'seats available'}',
                    style: const TextStyle(color: green, fontSize: 10, fontWeight: FontWeight.w700)),
                ]),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => SeatScreen(bus: bus, from: from, to: to, tamil: tamil))),
                  child: Text(tamil ? 'இருக்கைகள்' : 'Select seats'),
                ),
              ]),
            ]),
          )),
        )),
        Text(tamil
          ? 'குறிப்பு: இவை வடிவமைப்பு சோதனைக்கான மாதிரி பேருந்து விவரங்கள்.'
          : 'Note: These are sample bus details for design testing.',
          style: const TextStyle(color: Colors.blueGrey, fontSize: 11)),
      ],
    ),
  );

  Widget _timeBlock(String time, String city, bool start) => Expanded(
    child: Column(crossAxisAlignment: start ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(time, style: const TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)),
        Text(city, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.blueGrey, fontSize: 11)),
      ]),
  );
}

class SeatScreen extends StatefulWidget {
  final BusTrip bus;
  final String from, to;
  final bool tamil;
  const SeatScreen({super.key, required this.bus, required this.from,
    required this.to, required this.tamil});
  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  final Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    final total = widget.bus.fare * selected.length;
    return Scaffold(
      appBar: AppBar(title: Text(widget.tamil ? 'இருக்கையைத் தேர்வு செய்யுங்கள்' : 'Choose Your Seats')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
          child: Card(child: Padding(padding: const EdgeInsets.all(15),
            child: Row(children: [
              const Icon(Icons.directions_bus_rounded, color: blue, size: 30),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.bus.operatorName, style: const TextStyle(color: navy, fontWeight: FontWeight.w900)),
                Text('${widget.from} → ${widget.to}',
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
              ])),
            ]),
          )),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _legend(blue, widget.tamil ? 'காலி' : 'Available'),
            _legend(green, widget.tamil ? 'தேர்வு' : 'Selected'),
            _legend(const Color(0xFFD9DEE8), widget.tamil ? 'நிரம்பியது' : 'Booked'),
          ]),
        ),
        Expanded(child: Card(
          margin: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: Padding(padding: const EdgeInsets.all(18),
            child: Column(children: [
              Align(alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  decoration: BoxDecoration(color: canvas, borderRadius: BorderRadius.circular(10)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.airline_seat_recline_extra, color: Colors.blueGrey, size: 18),
                    const SizedBox(width: 6),
                    Text(widget.tamil ? 'ஓட்டுநர்' : 'Driver',
                      style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                  ]),
                )),
              const Divider(height: 25),
              Expanded(child: GridView.builder(
                itemCount: 32,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 13, mainAxisSpacing: 13,
                  childAspectRatio: 1.05),
                itemBuilder: (context, index) {
                  final seat = index + 1;
                  final isBooked = seat == 4 || seat == 9 || seat == 22;
                  final isSelected = selected.contains(seat);
                  final color = isBooked ? const Color(0xFFD9DEE8)
                      : isSelected ? green : paleBlue;
                  return InkWell(
                    onTap: isBooked ? null : () => setState(() {
                      if (isSelected) { selected.remove(seat); }
                      else { selected.add(seat); }
                    }),
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      decoration: BoxDecoration(color: color,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: isSelected ? green : Colors.transparent)),
                      child: Center(child: Text('$seat',
                        style: TextStyle(fontWeight: FontWeight.w900,
                          color: isBooked ? Colors.blueGrey : isSelected ? Colors.white : blue))),
                    ),
                  );
                },
              )),
            ]),
          ),
        )),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 20),
          decoration: const BoxDecoration(color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE9EDF4)))),
          child: Column(children: [
            Row(children: [
              Expanded(child: Text('${widget.tamil ? 'தேர்வு செய்த இருக்கைகள்' : 'Selected seats'}: '
                '${selected.isEmpty ? '-' : selected.toList()..sort()}',
                style: const TextStyle(color: navy, fontWeight: FontWeight.w700))),
              Text('₹$total', style: const TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 11),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: selected.isEmpty ? null : () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PassengerScreen(
                  bus: widget.bus, seats: selected.toList()..sort(), tamil: widget.tamil))),
              child: Text(widget.tamil ? 'தொடரவும்' : 'Continue'),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _legend(Color color, String label) => Row(children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(
      color: color, borderRadius: BorderRadius.circular(4))),
    const SizedBox(width: 5),
    Text(label, style: const TextStyle(color: Colors.blueGrey, fontSize: 10)),
  ]);
}

class PassengerScreen extends StatefulWidget {
  final BusTrip bus;
  final List<int> seats;
  final bool tamil;
  const PassengerScreen({super.key, required this.bus, required this.seats, required this.tamil});
  @override
  State<PassengerScreen> createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  String payment = 'UPI / Card';

  @override
  void dispose() { name.dispose(); phone.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final total = widget.bus.fare * widget.seats.length;
    return Scaffold(
      appBar: AppBar(title: Text(widget.tamil ? 'பயணி விவரங்கள்' : 'Passenger Details')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        _sectionTitle(widget.tamil ? 'பயணி தகவல்' : 'PASSENGER INFORMATION'),
        const SizedBox(height: 12),
        TextField(controller: name, textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: widget.tamil ? 'முழுப் பெயர்' : 'Full name',
            prefixIcon: const Icon(Icons.person_outline))),
        const SizedBox(height: 12),
        TextField(controller: phone, keyboardType: TextInputType.phone,
          maxLength: 10, decoration: InputDecoration(
            labelText: widget.tamil ? '10 இலக்க மொபைல் எண்' : '10-digit mobile number',
            prefixIcon: const Icon(Icons.phone_outlined))),
        const SizedBox(height: 12),
        _sectionTitle(widget.tamil ? 'கட்டண முறை' : 'PAYMENT METHOD'),
        const SizedBox(height: 8),
        Card(child: Column(children: [
          RadioListTile<String>(
            value: 'UPI / Card', groupValue: payment,
            onChanged: (v) => setState(() => payment = v!),
            title: const Text('Online (UPI / Card)'),
            secondary: const Icon(Icons.account_balance_wallet_outlined, color: blue)),
          const Divider(height: 1),
          RadioListTile<String>(
            value: 'Cash', groupValue: payment,
            onChanged: (v) => setState(() => payment = v!),
            title: Text(widget.tamil ? 'பஸ்ஸில் பணம்' : 'Cash on bus'),
            secondary: const Icon(Icons.payments_outlined, color: blue)),
        ])),
        const SizedBox(height: 15),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.tamil ? 'கட்டண விவரம்' : 'FARE SUMMARY',
              style: const TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 12)),
            const SizedBox(height: 12),
            _summaryRow(widget.tamil ? 'இருக்கைகள்' : 'Seats', widget.seats.join(', ')),
            _summaryRow(widget.tamil ? 'ஒரு இருக்கை' : 'Price per seat', '₹${widget.bus.fare}'),
            const Divider(height: 20),
            _summaryRow(widget.tamil ? 'மொத்தம்' : 'Total', '₹$total', bold: true),
          ],
        ))),
        const SizedBox(height: 18),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: () {
            if (name.text.trim().isEmpty || !RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone.text.trim())) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(widget.tamil
                  ? 'பெயர் மற்றும் சரியான 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்'
                  : 'Enter your name and a valid 10-digit mobile number')));
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmationScreen(
              bus: widget.bus, seats: widget.seats, passenger: name.text.trim(),
              payment: payment, tamil: widget.tamil)));
          },
          child: Text(widget.tamil ? 'முன்பதிவைத் தொடரவும்' : 'Continue to booking'),
        )),
      ]),
    );
  }

  Widget _sectionTitle(String title) => Text(title,
    style: const TextStyle(color: navy, fontSize: 12,
      letterSpacing: .8, fontWeight: FontWeight.w900));

  Widget _summaryRow(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(child: Text(label, style: TextStyle(
        color: bold ? navy : Colors.blueGrey,
        fontWeight: bold ? FontWeight.w900 : FontWeight.w500))),
      Text(value, style: TextStyle(color: navy,
        fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
        fontSize: bold ? 18 : 13)),
    ]),
  );
}

class ConfirmationScreen extends StatelessWidget {
  final BusTrip bus;
  final List<int> seats;
  final String passenger, payment;
  final bool tamil;
  const ConfirmationScreen({super.key, required this.bus, required this.seats,
    required this.passenger, required this.payment, required this.tamil});

  @override
  Widget build(BuildContext context) {
    final total = bus.fare * seats.length;
    final commission = (total * 0.15).round();
    return Scaffold(
      appBar: AppBar(title: Text(tamil ? 'முன்பதிவு சுருக்கம்' : 'Booking Summary')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
          Container(width: 76, height: 76,
            decoration: const BoxDecoration(color: Color(0xFFE6F7F0), shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: green, size: 48)),
          const SizedBox(height: 13),
          Text(tamil ? 'டெமோ முன்பதிவு தயார்!' : 'Demo booking prepared!',
            style: const TextStyle(color: navy, fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(tamil ? 'உங்கள் பயண விவரங்கள்' : 'Your journey details',
            style: const TextStyle(color: Colors.blueGrey)),
          const Divider(height: 30),
          _detail(tamil ? 'பேருந்து' : 'Bus operator', bus.operatorName),
          _detail(tamil ? 'வழித்தடம்' : 'Route', '${bus.from} → ${bus.to}'),
          _detail(tamil ? 'பயணி' : 'Passenger', passenger),
          _detail(tamil ? 'இருக்கைகள்' : 'Seats', seats.join(', ')),
          _detail(tamil ? 'கட்டண முறை' : 'Payment method', payment),
          const Divider(height: 26),
          _detail(tamil ? 'மொத்தக் கட்டணம்' : 'Total fare', '₹$total', big: true),
          _detail(tamil ? '15% கமிஷன் மதிப்பீடு' : 'Platform commission estimate (15%)',
            '₹$commission'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(13)),
            child: Text(tamil
              ? 'இது வடிவமைப்பு Demo மட்டுமே. உண்மையான டிக்கெட், பணப்பரிவர்த்தனை அல்லது இருக்கை முன்பதிவு செய்யப்படவில்லை.'
              : 'Design demo only. No real ticket, payment, or seat reservation has been created.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF8A5A13), fontSize: 11)),
          ),
        ]))),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          child: Text(tamil ? 'முகப்புக்குச் செல்லுங்கள்' : 'Back to Home'),
        )),
      ]),
    );
  }

  Widget _detail(String label, String value, {bool big = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Text(label, style: const TextStyle(color: Colors.blueGrey, fontSize: 12))),
      const SizedBox(width: 10),
      Flexible(child: Text(value, textAlign: TextAlign.end,
        style: TextStyle(color: navy, fontSize: big ? 20 : 12,
          fontWeight: FontWeight.w900))),
    ]),
  );
}
