import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Esharscreen extends StatelessWidget {
  const Esharscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline,size: 25,))
              ,
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).tr(),
            ],
          ),
          backgroundColor: Color(0xff073D5F),
          shadowColor: Colors.grey,
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.filter_alt_off_outlined, 'تم تاكيد الحجز',Colors.blue),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.black38),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.red),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
              Eshare(' م حجز الشقة يمكنك مراجعة التفاصيل كاملة تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
          
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
              Eshare('تم حجز الشقة يمكنك مراجعة التفاصيل كاملة', Icons.check_box, 'تم تاكيد الحجز',Colors.green),
            ],
          ),
        ),
    );
  }
}

Widget Eshare(String message,IconData icon,String title,Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(30)
        ),
      
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon,color: color,),
                SizedBox(width: 15,),
                Text(
                  title,
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
            SizedBox(height: 10,),
            Text(
              message,
              style:TextStyle(
                fontSize: 16
              )
            )
          ],
        ),
      ),
    );
  }