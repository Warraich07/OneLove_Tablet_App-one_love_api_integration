class CustomValidator {
  static String? email(String? value) {
    if (value!.isEmpty) {
      return ' Email is required';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return ' Please enter valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value!.isEmpty) {
      return ' Password is required';
    } else if (value.length < 8) {
      return ' Password should be greater than 7 digits';
    }
    return null;
  }

  static String? loginPassword(String? value) {
    if (value!.isEmpty) {
      return ' Password is required';
    }

    return null;
  }

  static String? confirmPassword(String? value, String oldPassword) {
    if (value!.isEmpty) {
      return ' Confirm Password is required';
    } else if (value.length < 6) {
      return ' Password should be greater then 6 digits';
    } else if (value != oldPassword) {
      return ' Confirm Password is not matched';
    }
    return null;
  }

  static String? isEmpty(String? value) {
    if (value!.isEmpty) {
      return ' Field cannot not be empty';
    }
    return null;
  }
  static String? isEmptyRoomNameOrAnimalName(String? value) {
    if (value!.isEmpty) {
      return ' Please enter room name/animal name';
    }
    return null;
  }

  static String? isEmptyProblem(String? value) {
    if (value!.isEmpty) {
      return ' Please write concern';
    }
    return null;
  }

  static String? isEmptyTitle(String? value) {
    if (value!.isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  static String? isEmptyUserName(String? value) {
    if (value!.isEmpty) {
      return ' Username is required';
    }
    return null;
  }

  static String? number(String? value) {
    if (value!.isEmpty) {
      return ' Phone Number is required';
    } else if (value.length < 6) {
      return 'Phone number should be at least 6 digits';
    }
    return null;
  }

  static String? lessThen2(String? value) {
    return (value!.length < 2) ? ' Enter more then 1 characters' : null;
  }

  static String? lessThen3(String? value) {
    return (value!.length < 3) ? ' Enter more then 2 characters' : null;
  }

  static String? lessThen4(String? value) {
    return (value!.length < 4) ? ' Enter more then 3 characters' : null;
  }

  static String? lessThen5(String? value) {
    return (value!.length < 5) ? ' Enter more then 4 characters' : null;
  }

  static String? greaterThen(String? input, double compareWith) {
    return (double.parse(input ?? '0') < compareWith)
        ? ' New input must be greater'
        : null;
  }

  static String? returnNull(String? value) => null;
}
