import { ethers, type InterfaceAbi } from 'ethers';
import abi from '../constants/abi.json';
import networks from '../config/networks.json';

// Define the structure for the contract ABI
interface AbiEntry {
  type: string;
  name?: string;
  inputs?: unknown[];
  outputs?: unknown[];
  stateMutability?: string;
}

export const getContract = async (chainId: string) => {
  if (!window.ethereum) throw new Error('No crypto wallet found');
  
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  
  const address = (networks as Record<string, string>)[chainId];
  if (!address) throw new Error('Unsupported network');

  // ABI is nested in BuyMeACoffee.json
  const contractAbi = (abi as { abi: AbiEntry[] }).abi;
  return new ethers.Contract(address, contractAbi as unknown as InterfaceAbi, signer);
};
