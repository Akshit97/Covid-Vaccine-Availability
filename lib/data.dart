class Data{
  String name;
  String address;
  String fee_type;
  String date;
  int min_age_limit;
  int available_capacity;
  Data(this.name,this.address, this.fee_type,this.date,this.min_age_limit,this.available_capacity);
  Data.fromJson(Map<String,dynamic> json)
  {
    name=json['name'];
    address=json['address'];
    fee_type=json['fee_type'];
    date=json['sessions'][0]["date"];
    min_age_limit=json['sessions'][0]["min_age_limit"];
    available_capacity=json['sessions'][0]["available_capacity"];
  }
}