# Nalia App

# References

- [flutter-v3 branch](https://github.com/thruthesky/nalia_app/tree/flutter-v3) works with the [v3 `0.1` branch](https://github.com/thruthesky/v3/tree/0.1) works with. These two would be a good example.

# Coding Guideline

## File upload

```dart
try {
  final re = await app.imageUpload(
      quality: 95,
      onProgress: (int p) {
        print('Progress: $p');
      });
  print('file upload success: $re');
} catch (e) {
  if (e == ERROR_IMAGE_NOT_SELECTED) {
  } else {
    print('e: $e');
  }
}
```

# Purchase and Jewelry System

- There are three jewelries in the system. And they can be used in many ways.

  - Diamond\
    A user can give diamond(s) to other user.
  - Gold\
    With gold, a user can recommend bag, watch, or ring to other user.

  - Siver\
    A user can do 'like' on other user's profile. It takes one siver.

- User can't send jewelry to himself, nor to same gender.
  - That means, men can't
    - send diamond
    - recommend luxur items
    - like
    - or any actions that are related with jewelry
      to other men.

## Bonus Jewelry

- User will have free daily bonus jewelry every day.
- Bonus jewelry is generated randomly.
  - The max number of jewelries is set on backend - `v3/config.php`.

## Purchase

- User

## Reward

- User who has achived the goal of luxury goal, the company will reward the user with expansive luxury items like bag, watch, or ring.

# Logic of Jewelry

## Logic of random jewelry generation

- The reason why jewelries are randomly generated is to prevent user's refund request. When user pays, the item is delivered to the user already.
-

## Logic of daily bonus

- On user login, or on midnight(12am), display a message(and an indicator) to user saying that they can redeem their daily bonus if they didn't get it for that day.

  - Redirect user to redeem page and let them touch "Get Daily Free Bonus" button to get bonus.

  - There are two advantages of this logic

    1. App can display advertisement(Admob) on the redeem page which will be a good earning point for the company.
    2. App can induce users to buy paid jewelry to get more jewelry and diamond.

  - Or app may silently generate bonus jewelry.

## Displaying Purchase History

## Displaying Free Daily Bonus History

## Displaying Recevied Jewelry
