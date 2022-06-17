
const navItem = {
    textDecoration:'none',
    fontFamily:"sans-serif", 
    fontWeight: '600', 
    fontSize: "18px",
    padding: "10px",
    textAlign: "center"
} as const;
const navButton = {
    textDecoration:'none',
    fontFamily:"sans-serif", 
    fontWeight: '600', 
    fontSize: "18px",
    padding: "10px"
} as const;
const navBar = {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    padding: '20px',
    paddingRight: '40px'
} as const;
const navContainer = {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    width: '50%',
    padding: '0px'
} as const;
const navLogo = {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-evenly',
    width: '30%',
    padding: '0px'
} as const;


export function Navbar(props){
    return (
        <div style={navBar}>
            <div style={navLogo}>
                <img src=""></img>
            </div>
            <div style={navContainer}>
                <a style={navItem} href="/">Home</a>
                <a style={navItem} href="/mint">About</a>
                <a style={navItem} href="/mint">How it Works</a>
                <a style={navItem} href="/mint">Become a Member</a>
                {props.data}
            </div>
        </div>
    )
}
