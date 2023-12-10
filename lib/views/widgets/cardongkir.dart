part of 'widgets.dart';

class CardOngkir extends StatefulWidget {
  final Costs costs;
  const CardOngkir(this.costs);

  @override
  State<CardOngkir> createState() => _CardOngkirState();
}

class _CardOngkirState extends State<CardOngkir> {
  @override
  Widget build(BuildContext context) {
    Costs c = widget.costs; 

    return Card(
      color: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        title: Text("${c.description} (${c.service})"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Biaya: Rp. ${c.cost[0].value}"),
                Text("Estimasi Sampai: ${c.cost[0].etd} hari kerja"),
              ],
            )
          ],
        )
      )
    );
  }
}