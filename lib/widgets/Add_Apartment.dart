import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق حجز الشقق',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tajawal',
      ),
      home: const AddApartmentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // بيانات القوائم المنسدلة
  String _selectedCity = 'الرياض';
  String _selectedDistrict = 'حي السليمانية';
  String _selectedType = 'شقة';
  String _selectedFurniture = 'مفروشة';
  
  // قيم اختيارية
  int _bedrooms = 2;
  int _bathrooms = 2;
  int _livingRooms = 1;
  int _parkingSpots = 1;
  
  // قائمة المرافق
  final Map<String, bool> _amenities = {
    'واي فاي': false,
    'موقف سيارات': true,
    'مسبح': false,
    'صالة رياضية': false,
    'مطبخ مجهز': true,
    'غسالة': true,
    'تكييف': true,
    'تدفئة': false,
    'مصعد': false,
    'حارس': false,
  };
  
  // قائمة الصور
  List<String> _photos = [
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400&auto=format&fit=crop',
  ];
  
  // متغيرات التحكم
  bool _isAvailable = true;
  bool _isNegotiable = false;
  bool _isLoading = false;
  
  // قوائم الاختيار
  final List<String> _cities = ['الرياض', 'جدة', 'الدمام', 'مكة', 'المدينة', 'أبها', 'الطائف'];
  final List<String> _districts = ['حي السليمانية', 'حي النرجس', 'حي الورود', 'حي العليا', 'حي الحمراء'];
  final List<String> _types = ['شقة', 'فيلا'];
  final List<String> _furnitureTypes = ['مفروشة', 'نصف مفروشة', 'غير مفروشة'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة عقار جديد'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان الرئيسي
                    const Text(
                      'معلومات العقار الأساسية',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // عنوان العقار
                    _buildTextField(
                      controller: _titleController,
                      label: 'عنوان العقار',
                      hint: 'مثال: شقة فاخرة في حي السليمانية',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال عنوان العقار';
                        }
                        return null;
                      },
                    ),
                    
                    // الوصف
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'وصف العقار',
                      hint: 'وصف مفصل للعقار والمنطقة المحيطة...',
                      icon: Icons.description,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال وصف للعقار';
                        }
                        if (value.length < 50) {
                          return 'يجب أن يكون الوصف 50 حرفًا على الأقل';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // معلومات الموقع
                    const Text(
                      'معلومات الموقع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            value: _selectedCity,
                            items: _cities,
                            label: 'المدينة',
                            onChanged: (value) {
                              setState(() {
                                _selectedCity = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdown(
                            value: _selectedDistrict,
                            items: _districts,
                            label: 'الحي',
                            onChanged: (value) {
                              setState(() {
                                _selectedDistrict = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    _buildTextField(
                      controller: _addressController,
                      label: 'العنوان التفصيلي',
                      hint: 'الشارع، رقم المبنى، الطابق...',
                      icon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال العنوان التفصيلي';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // معلومات العقار
                    const Text(
                      'مواصفات العقار',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            value: _selectedType,
                            items: _types,
                            label: 'نوع العقار',
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdown(
                            value: _selectedFurniture,
                            items: _furnitureTypes,
                            label: 'الفرش',
                            onChanged: (value) {
                              setState(() {
                                _selectedFurniture = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Column(
                      children: [
                        // _buildCounterCard(
                        //   label: 'غرف النوم',
                        //   value: _bedrooms,
                        //   onIncrement: () {
                        //     setState(() {
                        //       _bedrooms++;
                        //     });
                        //   },
                        //   onDecrement: () {
                        //     if (_bedrooms > 0) {
                        //       setState(() {
                        //         _bedrooms--;
                        //       });
                        //     }
                        //   },
                        //   icon: Icons.bed,
                        // ),
                        const SizedBox(height: 12),
                        _buildCounterCard(
                          label: 'عدد الحمامات',
                          value: _bathrooms,
                          onIncrement: () {
                            setState(() {
                              _bathrooms++;
                            });
                          },
                          onDecrement: () {
                            if (_bathrooms > 0) {
                              setState(() {
                                _bathrooms--;
                              });
                            }
                          },
                          icon: Icons.bathtub,
                        ),
                      
                    
                    const SizedBox(height: 12),
                    
                    _buildCounterCard(
                      label: 'عدد الغرف',
                      value: _livingRooms,
                      onIncrement: () {
                        setState(() {
                          _livingRooms++;
                        });
                      },
                      onDecrement: () {
                        if (_livingRooms > 0) {
                          setState(() {
                            _livingRooms--;
                          });
                        }
                      },
                      icon: Icons.bed,
                    ),
                    // const SizedBox(height: 12),
                    // _buildCounterCard(
                    //   label: 'مواقف سيارات',
                    //   value: _parkingSpots,
                    //   onIncrement: () {
                    //     setState(() {
                    //       _parkingSpots++;
                    //     });
                    //   },
                    //   onDecrement: () {
                    //     if (_parkingSpots > 0) {
                    //       setState(() {
                    //         _parkingSpots--;
                    //       });
                    //     }
                    //   },
                    //   icon: Icons.local_parking,
                    // ),
                    ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _areaController,
                      label: 'المساحة (م²)',
                      hint: 'مثال: 150',
                      icon: Icons.square_foot,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال المساحة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _priceController,
                      label: 'السعر (ليرة سورية)',
                      hint: 'مثال: 000 000 3',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال السعر';
                        }
                        if (int.tryParse(value) == null) {
                          return 'السعر يجب أن يكون رقماً';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // // المرافق
                    // const Text(
                    //   'المرافق المتاحة',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 12),
                    
                    // Wrap(
                    //   spacing: 8,
                    //   runSpacing: 8,
                    //   children: _amenities.keys.map((amenity) {
                    //     return FilterChip(
                    //       label: Text(amenity),
                    //       selected: _amenities[amenity]!,
                    //       onSelected: (selected) {
                    //         setState(() {
                    //           _amenities[amenity] = selected;
                    //         });
                    //       },
                    //       checkmarkColor: Colors.white,
                    //       selectedColor: Colors.blue,
                    //       backgroundColor: Colors.grey[200],
                    //       labelStyle: TextStyle(
                    //         color: _amenities[amenity]! ? Colors.white : Colors.black,
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                    
                    const SizedBox(height: 20),
                    
                    // الصور
                    const Text(
                      'صور العقار',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // معاينة الصور
                    if (_photos.isNotEmpty)
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photos.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _photos.length) {
                              return _buildAddPhotoCard();
                            }
                            return _buildPhotoCard(_photos[index], index);
                          },
                        ),
                      )
                    else
                      _buildAddPhotoCard(),
                    
                    const SizedBox(height: 16),
                    
                    // خيارات إضافية
                    const Text(
                      'خيارات إضافية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildSwitchCard(
                      title: 'العقار متاح',
                      value: _isAvailable,
                      icon: Icons.check_circle,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    // Expanded(
                    //   child: _buildSwitchCard(
                    //     title: 'السعر قابل للتفاوض',
                    //     value: _isNegotiable,
                    //     icon: Icons.attach_money,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _isNegotiable = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    
                    // معلومات الاتصال
                    const SizedBox(height: 20),
                    const Text(
                      'معلومات الاتصال',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف للتواصل',
                      hint: 'مثال: 0551234567',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        if (value.length < 10) {
                          return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // أزرار الحفظ والإلغاء
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'حفظ العقار',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  // مكونات مساعدة
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterCard({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: onDecrement,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoCard() {
    return GestureDetector(
      onTap: _addPhoto,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          )),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate, color: Colors.grey, size: 40),
              SizedBox(height: 8),
              Text(
                'إضافة صورة',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildPhotoCard(String imageUrl, int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? Colors.green : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  // دوال التحكم
  void _addPhoto() {
    // في التطبيق الحقيقي، هنا سيكون رفع صورة من الكاميرا أو المعرض
    setState(() {
      _photos.add('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400&auto=format&fit=crop');
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // محاكاة عملية الحفظ
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // عرض رسالة نجاح
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تمت الإضافة بنجاح'),
          content: const Text('تم إضافة العقار بنجاح وسيتم مراجعته من قبل الإدارة قريبًا.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعليمات إضافة عقار'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('• تأكد من صحة جميع المعلومات المدخلة'),
                SizedBox(height: 8),
                Text('• الصور يجب أن تكون واضحة وذات جودة عالية'),
                SizedBox(height: 8),
                Text('• الوصف المفصل يزيد من فرص الحجز'),
                SizedBox(height: 8),
                Text('• ستتم مراجعة العقار من قبل الإدارة قبل النشر'),
                SizedBox(height: 8),
                Text('• يمكنك تعديل العقار في أي وقت'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('حسناً'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}






