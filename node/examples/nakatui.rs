use std::{net, thread};
use std::path::PathBuf;

use nakamoto_client::{Client, Config, Error};
use nakamoto_client::network::{Network, Services};
use nakamoto_client::traits::Handle as _;
use nakamoto_node::{logger, Domain};

use argh::FromArgs;


#[derive(FromArgs)]
/// A Bitcoin light client.
pub struct Options {
    /// connect to the specified peers only
    #[argh(option)]
    pub connect: Vec<net::SocketAddr>,

    /// listen on one of these addresses for peer connections.
    #[argh(option)]
    pub listen: Vec<net::SocketAddr>,

    /// use the bitcoin test network (default: false)
    #[argh(switch)]
    pub testnet: bool,

    /// use the bitcoin signet network (default: false)
    #[argh(switch)]
    pub signet: bool,

    /// use the bitcoin regtest network (default: false)
    #[argh(switch)]
    pub regtest: bool,

    /// only connect to IPv4 addresses (default: false)
    #[argh(switch, short = '4')]
    pub ipv4: bool,

    /// only connect to IPv6 addresses (default: false)
    #[argh(switch, short = '6')]
    pub ipv6: bool,

    /// log level (default: info)
    #[argh(option, default = "log::Level::Info")]
    pub log: log::Level,

    /// root directory for nakamoto files (default: ~)
    #[argh(option)]
    pub root: Option<PathBuf>,
}

impl Options {
    pub fn from_env() -> Self {
        argh::from_env()
    }
}


/// The network reactor we're going to use.
type Reactor = nakamoto_net_poll::Reactor<net::TcpStream>;

/// Run the light-client.
fn client_run() -> Result<(), Error> {
    let cfg = Config::new(Network::Mainnet);

    // Create a client using the above network reactor.
    let client = Client::<Reactor>::new()?;
    let handle = client.handle();

    // Run the client on a different thread, to not block the main thread.
    thread::spawn(|| client.run(cfg).unwrap());

    // Wait for the client to be connected to a peer.
    handle.wait_for_peers(1, Services::default())?;

    // Ask the client to terminate.
    Ok(handle.shutdown()?)
}
fn main() -> Result<(), Error> {
    let opts = Options::from_env();

    logger::init(opts.log).expect("initializing logger for the first time");

    let network = if opts.testnet {
        Network::Testnet
    } else if opts.signet {
        Network::Signet
    } else if opts.regtest {
        Network::Regtest
    } else {
        Network::Mainnet
    };

    let domains = if opts.ipv4 && opts.ipv6 {
        vec![Domain::IPV4, Domain::IPV6]
    } else if opts.ipv4 {
        vec![Domain::IPV4]
    } else if opts.ipv6 {
        vec![Domain::IPV6]
    } else {
        vec![Domain::IPV4, Domain::IPV6]
    };

	//if let Err(e) = client_run() {
      //  log::error!(target: "client_run()", "Exiting: {}", e);
        //std::process::exit(1);

	//}
    if let Err(e) = nakamoto_node::run(&opts.connect, &opts.listen, opts.root, &domains, network) {
        log::error!(target: "node", "Exiting: {}", e);
        std::process::exit(1);
    }

    Ok(())
}
