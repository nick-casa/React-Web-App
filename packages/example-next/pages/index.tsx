import CoinbaseWalletCard from '../components/connectorCards/CoinbaseWalletCard'
import GnosisSafeCard from '../components/connectorCards/GnosisSafeCard'
import MetaMaskCard from '../components/connectorCards/MetaMaskCard'
import NetworkCard from '../components/connectorCards/NetworkCard'
import WalletConnectCard from '../components/connectorCards/WalletConnectCard'
import ProviderExample from '../components/ProviderExample'

//import Bleumi from '../components/connectorCards/Bleumi'

import Head from "next/head"
import "../flow/config";
import { useState, useEffect } from "react";
import * as fcl from "@onflow/fcl";


export default function Home() {
  // Tracks users status 
  const [user, setUser] = useState({loggedIn: null, addr: null})

  // Set the user to the current user 
  useEffect(() => fcl.currentUser.subscribe(setUser),[])

  const AuthedState = () => {
    return (<div>
      <div>Address {user?.addr ?? "No Address"}</div>
      <button onClick={fcl.unauthenticate}>Log Out</button>
    </div>)
  }
  const UnauthenticatedState = () => {
    return (
      <div>
        <button onClick={fcl.logIn}>Log In</button>
        <button onClick={fcl.signUp}>Sign Up</button>
      </div>)
  }

  return (
    <>
      <Head>
        <title>Test App</title>
        <meta name="description" content="Test"/>
        <link rel="icon" href="/favicon.png"/>
      </Head>

      <ProviderExample />
      <div style={{ display: 'flex', flexFlow: 'wrap', fontFamily: 'sans-serif' }}>
        <MetaMaskCard />
        <WalletConnectCard />
        <CoinbaseWalletCard />
        <NetworkCard />
        <GnosisSafeCard />
        {user.loggedIn ? <AuthedState /> : <UnauthenticatedState/>}
      </div>
    </>
  )

}
