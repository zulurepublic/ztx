# Zulu Republic's ZTX And AirDrop

<img src="zulu-icon.png" width="250" height="250">

## 1. What is ZTX and Its Airdrop

The ZuluToken(ZTX) contract is a standard ERC20 token. It is the token used within the Zulu Republic.

The Airdrop is our way of rewarding early adopters and seeding the Zulu Republic ecosystem with a free distribution of ZTX, no strings attached. During the Airdrop, the first 100,000 people to sign up will be able to claim a free ZTX deposit to their Zulu wallet, with no need to stake or deposit any of their own funds to participate.

## 2. How does it work?

Just by signing up with an email address and enabling 2-factor authentication (2FA), the first 100k adopters will be able to claim ZTX in the Airdrop. Once the Airdrop closes, people are then free to hold the ZTX in their Zulu Republic wallet, trade it on an exchange, and send it to other Zulu Republic users or any ERC20 compatible wallet. In the future, Zulu Republic Passport holders will also be able to spend ZTX at verified merchants and receive a 5% bonus on every transaction.

## 3. Why do an Airdrop?

Airdrops are often used by blockchain companies as an alternative to (or in addition to) conducting an ICO or token sale. Especially in cases where crowdfunding a project is not necessary, airdrops allow tokens to be publicly distributed without requiring people to "buy in" with their own funds.

By offering ZTX freely to anyone with an email address and phone number, we can align our distribution model with our core philosophy of open access and democratization, while also achieving the widest possible dissemination of ZTX.

Learn more about why we're conducting an airdrop [here](https://medium.com/zulurepublic/why-we-decided-not-to-do-an-ico-12547c617ab8).

Pre-enroll in the airdrop by [signing up](https://www.zulurepublic.io/signup/) now and activating 2-factor authentication. You'll receive a notification when the Airdrop starts and you can sign in and claim your ZTX.

## 4. Airdrop Statistics:

Total Airdrop Distribution: 100 million tokens
Tokens per registered user: 1000
Airdrop value: TBD based on opening exchange value
Start date: September 2018
End date: Upon completion of total Airdrop distribution

### Smart Contracts

-   Airdropper.sol

This contract distributes ZTX in the token's initial distribution phase. The first 100 thousand Zulu Republic citizens receive 1000 ZTX.

`triggerAirDrop` is the main function that distributes tokens to recipient addresses. You pass a recipient and she gets the ZTX tokens. A user who claimed their ZTX airdropped tokens cannot do so again.

-   ZuluToken.sol

Standard ERC20 token contract. It possesses the [ERC20 functions](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md).

## 5. Development

**Dependencies**

-   `node@9.5.x`

**Setting Up**

-   Clone this repository.

-   Install all [system dependencies](#development).

    -   `npm install`

-   Compile contract code

    -   `node_modules/.bin/truffle compile`

**Running Tests**

-   `npm run test`

**Test Coverage**

To see current test coverage, open `coverage/index.html` in a browser.

To generate test coverage, type:

-   `npm run cov`

## 6. Licensing

Lite.IM is licensed under the [Creative Commons Attribution ShareAlike](https://creativecommons.org/licenses/by-sa/4.0/) (CC-BY-SA-4.0) license. This means you are free to share or adapt it in any way.

## 7. Learn More

To learn more about Zulu Republic, visit the [Zulu Republic website](https://www.zulurepublic.io/) and [blog](www.medium.com/zulurepublic).

The Zulu Republic Telegram community can be found [here](https://t.me/ztxrepublic).

Follow Zulu Republic on Twitter at [@ztxrepublic](www.twitter.com/ztxrepublic).
