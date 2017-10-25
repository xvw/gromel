import '../css/app.css'
import "phoenix_html"
import { Socket } from "phoenix"
import Elm from '../elm/src/Main.elm'

const container = document.querySelector("#app")
const app = Elm.Main.embed(container)

const socket = new Socket("/socket", {})
socket.connect()

const channel = socket.channel("room:sample", {})
channel.join()

app.ports.pubMessage.subscribe(data =>
  channel
    .push("new_message", data)
    .receive("error", reasons => console.log("fetch failed", reasons))
)
channel.on("new_message", data =>
  app.ports.subMessage.send(data)
)
