import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFN = FocusNode();
  final _descriptionFN = FocusNode();
  var _imageUrlC = TextEditingController();
  final _imageUrlFN = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;
  var _product = Product(id: null, price: 0, title: '', description: '', imageUrl: '');
  Map defaut = {
   'title': '',
   'price': '',
   'description': '',
  'imageUrl': '',
  };

@override
  void initState() {
    _imageUrlFN.addListener(_updateUrl);
    super.initState();
  }

@override
  void didChangeDependencies() {
    if(_isInit){
        final prodId = ModalRoute.of(context).settings.arguments as String;
        if(!(prodId == null)){
          _product = Provider.of<Products>(context).findById(prodId);
          defaut= {
            'title': _product.title,
            'price': _product.price.toString(),
            'description': _product.description,
            'imageUrl': _product.imageUrl,
          };
          _imageUrlC.text = defaut['imageUrl'];
        }
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _priceFN.dispose();
    _descriptionFN.dispose();
    _imageUrlFN.removeListener(_updateUrl);
    _imageUrlC.dispose();
    _imageUrlFN.dispose();
    super.dispose();
  }

  void _updateUrl(){
if(!_imageUrlFN.hasFocus){
  if((!_imageUrlC.text.startsWith('http') && !_imageUrlC.text.startsWith('https')) ||
  (!_imageUrlC.text.endsWith('.png') && _imageUrlC.text.endsWith('.jpg') && _imageUrlC.text.endsWith('.jpeg'))){
    return;
  }
  setState(() {
    
  });
}
  }

  Future <void> _saveForm() async{
    if(_form.currentState.validate()){
       setState(() {
      _isLoading = true;
    });
      _form.currentState.save();
      if(_product.id != null){
        await Provider.of<Products>(context).updateProduct(_product.id, _product);
         setState(() {
          _isLoading = false;
          });
          Navigator.of(context).pop();
      }
      else{
        try{
       await Provider.of<Products>(context).addProduct(_product);
        }
        catch(error){
         await showDialog(context: context, builder: (ctx){
            return AlertDialog(
              title: Text("An error occured"),
              content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(onPressed: () {
                  Navigator.of(ctx).pop();
                 }, child: Text("Okay"))
              ],
            );
          });
        }
        finally{
           setState(() {
      _isLoading = false;
         });
            Navigator.of(context).pop();
        }
        
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Form(key: _form,
      child:_isLoading? Center(child: CircularProgressIndicator(),)//Sinon...
      :ListView(
        children: <Widget>[
          TextFormField(
            initialValue: defaut['title'],
            decoration: InputDecoration(labelText: 'Title'),
            textInputAction: TextInputAction.next,
            validator: (value){
              if(value.isEmpty){
                return 'Please Enter a title for the product';
              }
              else{
                return null;
              }
            },
            onFieldSubmitted: (text){
              if(text.isEmpty){
                return ;
              }
              else{
                return FocusScope.of(context).requestFocus(_priceFN);
              }
              },
               onSaved: (value){
              _product = Product(id: _product.id,
              isFavorite: _product.isFavorite,
               title: value,
               description: _product.description,
                price: _product.price,
                 imageUrl: _product.imageUrl);
            },
          ),
          TextFormField(
            initialValue: defaut['price'],
            decoration: InputDecoration(labelText: 'Price'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            focusNode: _priceFN,
            validator: (value){
              if(value.isEmpty){
                return 'Please Enter a price for the product';
              }
              else if(double.tryParse(value) == null || double.parse(value) <= 0){
                  return 'Please enter a valide number';
                }
              else {
                return null;
              }
            },
            onFieldSubmitted: (text){
              if(text.isNotEmpty){
                return;
              }
              else{
                return FocusScope.of(context).requestFocus(_descriptionFN);
              }
            },    
            onSaved: (value){
              _product = Product(id: _product.id,
              isFavorite: _product.isFavorite,
               title: _product.title,
                description: _product.description,
                 price: double.parse(value), imageUrl: _product.imageUrl);
            },        
          ),
          TextFormField(
            initialValue: defaut['description'],
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            focusNode: _descriptionFN, 
            validator: (value){
              if(value.isEmpty){
                return 'Please Enter a description for the product';
              }
              else if (value.length < 10){
                return 'Please enter at least 10 characters';
              }
              else{
                return null;
              }
            },
             onSaved: (value){
              _product = Product(id: _product.id,
              isFavorite: _product.isFavorite,
               title: _product.title,
                description: value,
                 price: _product.price,
                  imageUrl: _product.imageUrl);
            },            
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, right: 15),
              height: 100,
              width: 100,
              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey),),
              child: _imageUrlC.text.isEmpty? Center(child: Text("Enter a URL"),): FittedBox(child: Image.network(_imageUrlC.text, fit:BoxFit.cover,)),
            ),
            Expanded(
                child: TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                keyboardType: TextInputType.url,
                controller: _imageUrlC,
                focusNode: _imageUrlFN,
                validator: (value){
              if(value.isEmpty){
                return 'Please Enter a image URL for the product';
              }
              if(!value.startsWith('http') && !value.startsWith('https')){
                  return 'Please enter a valide URL';
                }
               if(!value.endsWith('.jpg') && !value.endsWith('.jpeg') && !value.endsWith('png')){
                  return 'Please enter a valide image format';
                }
              else {
                return null;
              }
            },
                 onSaved: (value){
              _product = Product(id: _product.id,
              isFavorite: _product.isFavorite,
               title: _product.title,
                description: _product.description,
                 price: _product.price,
                  imageUrl: value);
            },
            onFieldSubmitted:(_){ 
              _saveForm();
              },
              ),
            )
          ],)
        ],
      )),
    );
  }
}