import '../css/app.css'
import "phoenix_html"
import { Socket } from "phoenix"
import Elm from '../elm/src/Main.elm'

const container = document.querySelector("#app")
const app = Elm.Main.embed(container)
